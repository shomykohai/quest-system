# GdUnit generated TestSuite
class_name ActiveQuestPoolTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __source = 'res://addons/quest_system/active_pool.gd'
var _quest: Quest = Quest.new()

func before() -> void:
	_quest.id = 1
	_quest.quest_name = "Test"
	_quest.quest_description = "This is a Test quest."
	_quest.quest_objective = "Run the tests without errors"

func test_update_objective() -> void:
	QuestSystem.active.add_quest(_quest)
	assert_signal(_quest).is_emitted("updated")
	QuestSystem.active.update_objective(_quest.id)
