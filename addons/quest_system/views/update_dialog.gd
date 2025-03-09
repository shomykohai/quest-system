@tool
extends AcceptDialog

signal updated

const DOWNLOAD_URL: String = "https://github.com/shomykohai/quest-system/archive/refs/tags/%s.zip"
const TEMP_FILE_PATH: String = "user://quest_system_temp.zip"

@onready var version_label: RichTextLabel = %VersionLabel
@onready var download_button: Button = %DownloadButton
@onready var http_request: HTTPRequest = %HTTPRequest
@onready var release_notes: TextEdit = %ReleaseNotes

var update_status: String = ""

var new_ver: String = ""
var old_ver: String = ""
var plugin_path: String = ""


func prepare() -> void:
	new_ver = get_meta("new_ver")
	old_ver = get_meta("old_ver")
	plugin_path = get_meta("plugin_path")
	release_notes.text = get_meta("release_notes")
	version_label.text = version_label.text % [new_ver, old_ver]
	%LinkButton.uri = "https://github.com/shomykohai/quest-system/releases/tag/%s" % new_ver
	title = new_ver


func _save_zip(bytes: PackedByteArray) -> void:
	var file := FileAccess.open(TEMP_FILE_PATH, FileAccess.WRITE)
	file.store_buffer(bytes)
	file.close()


func _on_download_button_pressed():
	http_request.request(DOWNLOAD_URL % new_ver)
	download_button.text = "Downloading..."
	download_button.disabled = true


func _on_http_request_request_completed(result, response_code, headers, body):
	if result != HTTPRequest.RESULT_SUCCESS:
		download_button.text = "Download failed. Try again later."
		download_button.disabled = false
		update_status = "failed"
		updated.emit()
		return

	_save_zip(body)

	var zip := ZIPReader.new()
	zip.open(TEMP_FILE_PATH)
	var files := zip.get_files()

	var zip_base_path: String = files[1]
	var save_path: String = plugin_path.get_base_dir()

	# Remove archive and repo base path from file list
	files.remove_at(0)
	files.remove_at(0)

	OS.move_to_trash(ProjectSettings.globalize_path(plugin_path))

	for path in files:
		var new_path := path.replace(zip_base_path, "")
		if path.ends_with("/"):
			DirAccess.make_dir_recursive_absolute(save_path + "/%s" % new_path)
		else:
			var file := FileAccess.open(save_path + "/%s" % new_path, FileAccess.WRITE)
			file.store_buffer(zip.read_file(path))

	zip.close()
	DirAccess.remove_absolute(TEMP_FILE_PATH)

	update_status = "updated"
	updated.emit()

	download_button.text = "Updated!"
	version_label.text = "You're running the last version of QuestSystem."
