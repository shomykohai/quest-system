@tool
extends EditorPlugin

const REMOTE_RELEASE_URL: String = "https://api.github.com/repos/shomykohai/quest-system/releases"
const QuestPropertyTranslationPlugin = preload("./translation_plugin.gd")
const QuestSystemSettings = preload("./settings.gd")

var update_button: Button = null
var translation_plugin: QuestPropertyTranslationPlugin

func _enter_tree() -> void:
	QuestSystemSettings.initialize(_get_plugin_path())

	# Override default autoload script path
	var autoload_path: String = QuestSystemSettings.get_config_setting("autoload_script_path", "quest_manager.gd")
	if autoload_path != "quest_manager.gd" and autoload_path != _get_plugin_path() + "/quest_manager.gd":
		if ResourceLoader.exists(autoload_path):
			var autoload = load(autoload_path).new()
			if autoload == null or not autoload is AbstractQuestManagerAPI:
				print_rich("[color=red][!][/color] [b]Cannot override default autoload script!\n[color=red]The script is not valid.[/color]\nUsing default script. Check QuestSystem settings.[/b]")
				autoload_path = "quest_manager.gd"
			autoload.queue_free()
		else:
			print_rich("[color=red][!][/color] [b]Cannot override default autoload script!\n[color=red]The script does not exist.[/color]\nUsing default script. Check QuestSystem settings.[/b]")
			autoload_path = "quest_manager.gd"

	add_autoload_singleton("QuestSystem", autoload_path)

	# Handle editor stuff
	if Engine.is_editor_hint():
		translation_plugin = QuestPropertyTranslationPlugin.new()
		add_translation_parser_plugin(translation_plugin)
		# Check for new version
		if QuestSystemSettings.get_config_setting("check_for_updates_on_startup", true):
			var http_request := HTTPRequest.new()
			http_request.request_completed.connect(_http_request_completed)
			EditorInterface.get_base_control().add_child(http_request)
			http_request.request(REMOTE_RELEASE_URL)
			await http_request.request_completed
			http_request.queue_free()


func _exit_tree() -> void:
	remove_autoload_singleton("QuestSystem")
	remove_translation_parser_plugin(translation_plugin)
	# Ensure the update button is freed
	if update_button:
		update_button.queue_free()
	translation_plugin = null


func _version_to_int(ver: String) -> int:
	var parts: Array = ver.split(".")
	return parts[0].to_int() * 10000 + parts[1].to_int() * 100 + parts[2].to_int()


func _get_plugin_icon() -> Texture2D:
	return load(_get_plugin_path() + "/assets/quest_resource.svg")


func _get_plugin_path() -> String:
	return get_script().resource_path.get_base_dir()


func _http_request_completed(result: int, _response_code: int, _headers: PackedStringArray, body: PackedByteArray):
	if result != HTTPRequest.RESULT_SUCCESS:
		return

	var data: Array[Dictionary]
	data.assign(JSON.parse_string(body.get_string_from_utf8()))


	var current_project_version: String = ProjectSettings.get_setting("application/config/features")[0]
	var versions: Array[Dictionary] = data.filter(
		func(release):
			# QuestSystem releases on GitHub are tagged as: "major.minor.patch". We also need to check if the major version is less than 2
			if current_project_version.split(".")[1].to_int() <= 3:
				# We are in Godot 4.0-4.3, so we avoid updating to QuestSystem 2.0, which is only compatible with Godot 4.4+
				# We only check for major version if we are in Godot 4.0-4.3, but allow the user to update to v2 if they are in Godot 4.4+
				var same_major: bool = release["tag_name"].split(".")[0] == get_plugin_version().split(".")[0]
				return _version_to_int(release["tag_name"]) > _version_to_int(get_plugin_version()) && same_major

			# This is for Godot 4.4+ where we only check if the release is newer than the current version,
			# and that the minumum Godot version is less or equal than the current project version.
			# The minimum Godot version will be declared in the tag_name: "major.minor.patch.godot_version"
			# This also ensures retro-compatibility with the old version tags
			var ver = release["tag_name"].split(".")
			var project_version_as_number = current_project_version.split(".")[0].to_int() * 10 + current_project_version.split(".")[0].to_int()
			var minimum_godot_version = project_version_as_number
			# Make sure the tag was declared correctly, and if so, we get the actual minumum version from the tag
			if ver.size() > 3:
				minimum_godot_version = ver[3].split("_")[0].to_int() * 10 + ver[3].split("_")[1].to_int()

			return _version_to_int(release["tag_name"]) > _version_to_int(get_plugin_version()) && project_version_as_number >= minimum_godot_version
	)


	if versions.size() == 0:
		return

	var latest_version: Dictionary = versions[0]

	var title_bar: Node = null

	# Here we get the title bar node in a unconventional way
	for node in EditorInterface.get_base_control().get_children(true):
		if node is VBoxContainer:
			title_bar = node.get_children(true)[0]
			break

	# Get only the version number without the trailing Godot minumum version
	var version_label: String = latest_version["tag_name"].rsplit(".", false, 1)[0]

	update_button = Button.new()
	update_button.add_theme_color_override("font_color", Color.ORANGE)
	update_button.text = version_label
	update_button.icon = _get_plugin_icon()
	update_button.pressed.connect(_on_update_button_pressed.bind(get_plugin_version(), version_label, latest_version["body"]))
	title_bar.add_child(update_button)
	title_bar.move_child(update_button, title_bar.get_child_count(true) - 3)


func _on_update_button_pressed(old_ver: String, new_ver: String, release_notes: String) -> void:
	var update_panel: AcceptDialog = load(_get_plugin_path()+"/views/update_dialog.tscn").instantiate()
	update_panel.set_meta("old_ver", old_ver)
	update_panel.set_meta("new_ver", new_ver)
	update_panel.set_meta("plugin_path", _get_plugin_path())
	update_panel.set_meta("release_notes", release_notes)
	update_button.add_child(update_panel)
	update_panel.popup_centered()
	update_panel.prepare()
	await update_panel.updated
	if update_panel.update_status == "" or update_panel.update_status == "failed":
		print_rich("[color=red][!][/color] [b]Update failed![/b]\n[color=red]Please check the console for more information.[/color]")
		update_panel.queue_free()
		return

	update_panel.queue_free()
	update_button.queue_free()
	EditorInterface.get_resource_filesystem().scan()
	EditorInterface.call_deferred("set_plugin_enabled", "quest_system", true)
	EditorInterface.set_plugin_enabled("quest_system", false)
	print_rich("[color=cyan][!][/color] [b]QuestSystem updated to version: [color=cyan]%s[/color][/b]" % new_ver)
