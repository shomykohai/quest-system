# GdUnit generated TestSuite
class_name QuestSystemSettingsTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __source = 'res://addons/quest_system/settings.gd'


func test_get_config_setting() -> void:
	var setting: bool = ProjectSettings.get_setting("quest_system/config/require_objective_completed", true)
	assert_bool(QuestSystemSettings.get_config_setting("require_objective_completed", true)).is_equal(setting)
