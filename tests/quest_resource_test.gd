# GdUnit generated TestSuite
class_name QuestResourceTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __source = 'res://addons/quest_system/quest_resource.gd'

var _quest: Quest = Quest.new()
var signal_received: bool = false

func before() -> void:
	_quest.id = 1
	_quest.quest_name = "Test"
	_quest.quest_description = "This is a Test quest."
	_quest.quest_objective = "Run the tests without errors"

func before_test() -> void:
	signal_received = false

func test_update() -> void:
	_quest.updated.connect(_receive_signal)
	_quest.update()
	_quest.updated.disconnect(_receive_signal)
	assert_bool(signal_received).is_true()

func test_complete() -> void:
	_quest.completed.connect(_receive_signal)
	_quest.complete()
	_quest.completed.disconnect(_receive_signal)
	assert_bool(signal_received).is_true()

func test_start() -> void:
	_quest.started.connect(_receive_signal)
	_quest.start()
	_quest.started.disconnect(_receive_signal)
	assert_bool(signal_received).is_true()

func test_serialize() -> void:
	var expected_dict: Dictionary = {
			"quest_name": "Test",
			"quest_description": "This is a Test quest.",
			"quest_objective": "Run the tests without errors",
			"objective_completed": false
		}
	assert_dict(_quest.serialize()).is_equal(expected_dict)

func test_deserialize() -> void:
	var expected_dict: Dictionary = {
			"quest_name": "Test",
			"quest_description": "This is a Test quest.",
			"quest_objective": "Run the tests without errors",
			"objective_completed": false
		}
	_quest.deserialize(expected_dict)
	assert_dict(_quest.serialize()).is_equal(expected_dict)

func _receive_signal() -> void:
	signal_received = true
