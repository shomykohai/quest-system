# GdUnit generated TestSuite
class_name QuestManagerTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __source = 'res://addons/quest_system/quest_manager.gd'
const base_pool_path = "res://addons/quest_system/base_quest_pool.gd"

var _quest: Quest = Quest.new()

func before() -> void:
	_quest.id = 1
	_quest.quest_name = "Test"
	_quest.quest_description = "This is a Test quest."
	_quest.quest_objective = "Run the tests without errors"

func before_test() -> void:
	## Remove the quest from every pool before each test
	QuestSystem.reset_pool("")

	## Reset objective completed
	_quest.objective_completed = false


#region: Quest API

func test_start_quest() -> void:
	assert_bool(!QuestSystem.is_quest_active(_quest) && !QuestSystem.is_quest_completed(_quest)).is_true()
	QuestSystem.start_quest(_quest)
	assert_bool(QuestSystem.is_quest_active(_quest)).is_true()

func test_complete_quest() -> void:
	assert_bool(QuestSystem.is_quest_completed(_quest)).is_false()
	QuestSystem.start_quest(_quest)
	_quest.objective_completed = true
	QuestSystem.complete_quest(_quest)
	assert_bool(QuestSystem.is_quest_completed(_quest)).is_true()

func test_update_quest() -> void:
	QuestSystem.start_quest(_quest)
	assert_bool(QuestSystem.is_quest_active(_quest)).is_true()
	QuestSystem.update_quest(_quest)

func test_mark_quest_as_available() -> void:
	QuestSystem.mark_quest_as_available(_quest)
	assert_bool(QuestSystem.is_quest_available(_quest)).is_true()

func test_get_available_quests() -> void:
	QuestSystem.mark_quest_as_available(_quest)
	assert_array(QuestSystem.get_available_quests()).is_equal([_quest])

func test_get_active_quests() -> void:
	QuestSystem.start_quest(_quest)
	assert_array(QuestSystem.get_active_quests()).is_equal([_quest])

func test_is_quest_available() -> void:
	QuestSystem.mark_quest_as_available(_quest)
	assert_bool(QuestSystem.is_quest_available(_quest)).is_true()

func test_is_quest_active() -> void:
	QuestSystem.start_quest(_quest)
	assert_bool(QuestSystem.is_quest_active(_quest)).is_true()

func test_is_quest_completed() -> void:
	QuestSystem.start_quest(_quest)
	assert_bool(QuestSystem.is_quest_active(_quest)).is_true()
	_quest.objective_completed = true
	QuestSystem.complete_quest(_quest)
	assert_bool(QuestSystem.is_quest_active(_quest)).is_false()
	assert_bool(QuestSystem.is_quest_completed(_quest)).is_true()


func test_is_quest_in_pool() -> void:
	QuestSystem.start_quest(_quest)
	assert_bool(QuestSystem.is_quest_in_pool(_quest, "Active"))

func test_call_quest_method() -> void:
	QuestSystem.start_quest(_quest)
	QuestSystem.call_quest_method(_quest.id, &"update", [])
	assert_signal(_quest).is_emitted(&"updated")

func test_set_quest_property() -> void:
	QuestSystem.start_quest(_quest)
	assert_bool(QuestSystem.is_quest_active(_quest)).is_true()
	QuestSystem.set_quest_property(_quest.id, &"quest_name", "Name Changed")
	assert_str(_quest.quest_name).is_equal("Name Changed")
	QuestSystem.set_quest_property(_quest.id, &"quest_name", "Test")
	assert_str(_quest.quest_name).is_equal("Test")

func test_get_quest_property() -> void:
	QuestSystem.start_quest(_quest)
	assert_bool(QuestSystem.is_quest_active(_quest)).is_true()
	assert_str(QuestSystem.get_quest_property(_quest.id, &"quest_name")).is_equal("Test")

#endregion

#region: Manager API

func test_add_new_pool() -> void:
	QuestSystem.add_new_pool(base_pool_path, &"NewPool")
	var new_pool: BaseQuestPool = QuestSystem.get_pool(&"NewPool")
	assert_array(QuestSystem.get_all_pools()).contains([new_pool])
	QuestSystem.remove_pool(&"NewPool")

func test_remove_pool() -> void:
	QuestSystem.add_new_pool(base_pool_path, &"NewPool")
	var new_pool: BaseQuestPool = QuestSystem.get_pool(&"NewPool")
	assert_array(QuestSystem.get_all_pools()).contains([new_pool])
	QuestSystem.remove_pool(&"NewPool")
	await get_tree().process_frame # Wait a frame for queue_free to take action
	assert_array(QuestSystem.get_all_pools()).not_contains([new_pool])

func test_get_pool() -> void:
	assert_object(QuestSystem.get_pool("Active")).is_not_null()
	assert_object(QuestSystem.get_pool("TestPool")).is_null()

func test_get_all_pools() -> void:
	var expected_children: Array[BaseQuestPool] = []
	expected_children.append(QuestSystem.available)
	expected_children.append(QuestSystem.active)
	expected_children.append(QuestSystem.completed)
	assert_array(QuestSystem.get_all_pools()).is_equal(expected_children)

func test_move_quest_to_pool() -> void:
	QuestSystem.start_quest(_quest)
	assert_bool(QuestSystem.is_quest_active(_quest)).is_true()
	assert_bool(QuestSystem.is_quest_completed(_quest)).is_false()
	QuestSystem.move_quest_to_pool(_quest, &"Active", &"Completed")
	assert_bool(QuestSystem.is_quest_active(_quest)).is_false()
	assert_bool(QuestSystem.is_quest_completed(_quest)).is_true()

func test_reset_pool() -> void:
	var _second_quest := Quest.new()
	_second_quest.id = 2
	_second_quest.quest_name = "Test2"
	_second_quest.quest_description = "This is the 2nd Test quest."
	_second_quest.quest_objective = "Run the tests without errors"

	QuestSystem.start_quest(_quest)
	assert_bool(QuestSystem.is_quest_active(_quest)).is_true()
	QuestSystem.start_quest(_second_quest)
	QuestSystem.complete_quest(_quest)
	assert_bool(QuestSystem.is_quest_active(_second_quest)).is_true()
	assert_bool(QuestSystem.is_quest_completed(_quest)).is_true()

	QuestSystem.reset_pool("Active")
	assert_bool(QuestSystem.is_quest_active(_second_quest)).is_false()
	assert_bool(QuestSystem.is_quest_completed(_quest)).is_true()

	QuestSystem.start_quest(_second_quest)
	QuestSystem.reset_pool("")
	assert_bool(QuestSystem.is_quest_active(_second_quest)).is_false()
	assert_bool(QuestSystem.is_quest_completed(_quest)).is_false()

func test_quests_as_dict() -> void:
	QuestSystem.start_quest(_quest)
	assert_bool(QuestSystem.is_quest_active(_quest)).is_true()
	var expected_dict: Dictionary = {"available": [], "active": [1], "completed": []}
	assert_dict(QuestSystem.quests_as_dict()).is_equal(expected_dict)

func test_dict_to_quests() -> void:
	var expected_dict: Dictionary = {"available": [], "active": [1], "completed": []}
	QuestSystem.dict_to_quests(expected_dict, [_quest])
	assert_dict(QuestSystem.quests_as_dict()).is_equal(expected_dict)

func test_serialize_quests() -> void:
	QuestSystem.start_quest(_quest)
	assert_bool(QuestSystem.is_quest_active(_quest)).is_true()
	var expected_dict: Dictionary = {
		"1": {
			"quest_name": "Test",
			"quest_description": "This is a Test quest.",
			"quest_objective": "Run the tests without errors",
			"objective_completed": false
		}}
	assert_dict(QuestSystem.serialize_quests()).is_equal(expected_dict)

func test_deserialize_quests() -> void:
	QuestSystem.start_quest(_quest)
	assert_bool(QuestSystem.is_quest_active(_quest)).is_true()
	var expected_dict: Dictionary = {
		"1": {
			"quest_name": "Test",
			"quest_description": "This is a deserialized quest.",
			"quest_objective": "Run the tests without errors",
			"objective_completed": true
		}}
	QuestSystem.deserialize_quests(expected_dict)
	assert_dict(QuestSystem.serialize_quests()).is_equal(expected_dict)

#endregion
