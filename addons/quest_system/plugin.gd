@tool
extends EditorPlugin

const QuestPropertyTranslationPlugin = preload("res://addons/quest_system/translation_plugin.gd")

var translation_plugin: QuestPropertyTranslationPlugin

func _enter_tree() -> void:
	add_autoload_singleton("QuestSystem", "quest_manager.gd")
	if Engine.is_editor_hint():
		translation_plugin = QuestPropertyTranslationPlugin.new()
		add_translation_parser_plugin(translation_plugin)


func _exit_tree() -> void:
	remove_autoload_singleton("QuestSystem")
	remove_translation_parser_plugin(translation_plugin)
	translation_plugin = null
