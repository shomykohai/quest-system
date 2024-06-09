@tool
extends RefCounted
class_name QuestSystemSettings

const MAIN_CATEGORY: StringName = "quest_system"
const CONFIG_CATEGORY: StringName = MAIN_CATEGORY + "/config"

static func initialize(plugin_path: StringName) -> void:
	# Addon settings
	_init_setting(
		CONFIG_CATEGORY + "/check_for_updates_on_startup",
		true, TYPE_BOOL)

	# Pools
	_init_setting(
		CONFIG_CATEGORY + "/available_quest_pool_path",
		"%s/available_pool.gd" % plugin_path,
		TYPE_STRING, PROPERTY_HINT_FILE)
	_init_setting(
		CONFIG_CATEGORY + "/active_quest_pool_path",
		"%s/active_pool.gd" % plugin_path,
		TYPE_STRING, PROPERTY_HINT_FILE)
	_init_setting(
		CONFIG_CATEGORY + "/completed_quest_pool_path",
		"%s/completed_pool.gd" % plugin_path,
		TYPE_STRING, PROPERTY_HINT_FILE)
	_init_setting(
		CONFIG_CATEGORY + "/additional_pools",
		[],
		TYPE_ARRAY, PROPERTY_HINT_TYPE_STRING, ("%s:" % TYPE_STRING))

	# Default Pools settings
	_init_setting(
		CONFIG_CATEGORY + "/require_objective_completed",
		true, TYPE_BOOL)



static func _init_setting(name: String, default_value: Variant, type:=typeof(default_value), hint:=PROPERTY_HINT_NONE, hint_string:=""):
	if not ProjectSettings.has_setting(name):
		ProjectSettings.set_setting(name, default_value)

	ProjectSettings.set_initial_value(name, default_value)

	var hint_info: Dictionary = {
		"name": name,
		"type": type,
		"hint": hint,
		"hint_string": hint_string
	}
	ProjectSettings.add_property_info(hint_info)
	ProjectSettings.save()

static func get_config_setting(name: String, default: Variant = null) -> Variant:
	return ProjectSettings.get_setting(CONFIG_CATEGORY + "/" + name, default)
