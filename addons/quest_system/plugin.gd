@tool
extends EditorPlugin

const REMOTE_RELEASE_URL: String = "https://api.github.com/repos/shomykohai/quest-system/releases/latest"
const QuestPropertyTranslationPlugin = preload("./translation_plugin.gd")
const QuestSystemSettings = preload("./settings.gd")

var update_button: Button = null
var translation_plugin: QuestPropertyTranslationPlugin

func _enter_tree() -> void:
	QuestSystemSettings.initialize(_get_plugin_path())
	add_autoload_singleton("QuestSystem", "quest_manager.gd")
	if Engine.is_editor_hint():
		translation_plugin = QuestPropertyTranslationPlugin.new()
		add_translation_parser_plugin(translation_plugin)
		# Check for new version
		var http_request := HTTPRequest.new()
		http_request.request_completed.connect(_http_request_completed)
		EditorInterface.get_base_control().add_child(http_request)
		http_request.request(REMOTE_RELEASE_URL)
		await http_request.request_completed
		http_request.queue_free()

func _exit_tree() -> void:
	remove_autoload_singleton("QuestSystem")
	remove_translation_parser_plugin(translation_plugin)
	translation_plugin = null

func _version_to_int(ver: String) -> int:
	var parts: Array = ver.split(".")
	return parts[0].to_int() * 100 + parts[1].to_int() * 10 + parts[2].to_int()

func _get_plugin_icon() -> Texture2D:
	return load(_get_plugin_path() + "/assets/quest_resource.svg")

func _get_plugin_path() -> String:
	return get_script().resource_path.get_base_dir()

func _http_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray):
	if result != HTTPRequest.RESULT_SUCCESS:
		return
	
	var data: Dictionary = JSON.parse_string(body.get_string_from_utf8())
	if _version_to_int(data["tag_name"]) <= _version_to_int(get_plugin_version()):
		return
	
	var title_bar: Node = null
	
	# Here we get the title bar node in a unconventional way
	for node in EditorInterface.get_base_control().get_children(true):
		if node is VBoxContainer:
			title_bar = node.get_children(true)[0]
			break

	update_button = Button.new()
	update_button.add_theme_color_override("font_color", Color.LIME_GREEN)
	update_button.text = data["tag_name"]
	update_button.icon = _get_plugin_icon()
	update_button.pressed.connect(_on_update_button_pressed.bind(get_plugin_version(), data["tag_name"]))
	title_bar.add_child(update_button)
	title_bar.move_child(update_button, title_bar.get_child_count(true) - 3)
	
func _on_update_button_pressed(old_ver: String, new_ver: String) -> void:
	var update_panel: AcceptDialog = load(_get_plugin_path()+"/views/update_dialog.tscn").instantiate()
	update_panel.set_meta("old_ver", old_ver)
	update_panel.set_meta("new_ver", new_ver)
	update_panel.set_meta("plugin_path", _get_plugin_path())
	update_button.add_child(update_panel)
	update_panel.popup_centered()
	update_panel.prepare()
	await update_panel.updated
	update_panel.queue_free()
	update_button.queue_free()
	EditorInterface.get_resource_filesystem().scan()
	EditorInterface.call_deferred("set_plugin_enabled", "quest_system", true)
	EditorInterface.set_plugin_enabled("quest_system", false)
	print_rich("[color=cyan][!][/color] [b]QuestSystem updated to version: [color=cyan]%s[/color][/b]" % new_ver)
