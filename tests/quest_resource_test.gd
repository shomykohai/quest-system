# GdUnit generated TestSuite
class_name QuestResourceTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __source = 'res://addons/quest_system/quest_resource.gd'

var _quest: Quest = Quest.new()

func before() -> void:
	_quest.id = 1
	_quest.quest_name = "Test"
	_quest.quest_description = "This is a Test quest."
	_quest.quest_objective = "Run the tests without errors"

func test_update() -> void:
	_quest.update()
	assert_signal(_quest).is_emitted(&"updated")

func test_complete() -> void:
	_quest.complete()
	assert_signal(_quest).is_emitted(&"completed")

func test_start() -> void:
	_quest.start()
	assert_signal(_quest).is_emitted(&"started")

func test_objective_status_updated_signal() -> void:
	_quest.objective_completed = true
	assert_signal(_quest).is_emitted(&"objective_status_updated")
	_quest.objective_completed = false
	assert_signal(_quest).is_emitted(&"objective_status_updated")

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
