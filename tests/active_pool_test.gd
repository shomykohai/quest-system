# GdUnit generated TestSuite
class_name ActiveQuestPoolTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __source = 'res://addons/quest_system/active_pool.gd'
var _quest: Quest = Quest.new()
var signal_received: bool = false

func before() -> void:
	_quest.id = 1
	_quest.quest_name = "Test"
	_quest.quest_description = "This is a Test quest."
	_quest.quest_objective = "Run the tests without errors"
	QuestSystem.start_quest(_quest)

func test_update_objective() -> void:
	_quest.updated.connect(_receive_signal)
	QuestSystem.active.update_objective(_quest.id)
	_quest.updated.disconnect(_receive_signal)
	assert_bool(signal_received).is_true()

func _receive_signal() -> void:
	signal_received = true
