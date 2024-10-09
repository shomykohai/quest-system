# GdUnit generated TestSuite
class_name BaseQuestPoolTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __source = 'res://addons/quest_system/base_quest_pool.gd'

var _quest: Quest = Quest.new()
var pool: BaseQuestPool = null

func before() -> void:
	_quest.id = 1
	_quest.quest_name = "Test"
	_quest.quest_description = "This is a Test quest."
	_quest.quest_objective = "Run the tests without errors"
	QuestSystem.add_new_pool(__source, "TestPool")
	pool = QuestSystem.get_pool("TestPool")

func before_test() -> void:
	pool.reset()
	pool.add_quest(_quest)

func after() -> void:
	QuestSystem.remove_pool(&"TestPool")

func test_add_quest() -> void:
	assert_bool(QuestSystem.is_quest_in_pool(_quest, &"TestPool")).is_true()

func test_remove_quest() -> void:
	assert_bool(QuestSystem.is_quest_in_pool(_quest, &"TestPool")).is_true()
	pool.remove_quest(_quest)
	assert_bool(QuestSystem.is_quest_in_pool(_quest, &"TestPool")).is_false()

func test_get_quest_from_id() -> void:
	assert_bool(QuestSystem.is_quest_in_pool(_quest, &"TestPool")).is_true()
	assert_object(pool.get_quest_from_id(1)).is_equal(_quest)

func test_is_quest_inside() -> void:
	assert_bool(pool.is_quest_inside(_quest)).is_equal(_quest in pool.quests)

func test_get_ids_from_quests() -> void:
	assert_array(pool.get_ids_from_quests()).contains_exactly([1])

func test_get_all_quests() -> void:
	assert_array(pool.get_all_quests()).contains_exactly([_quest])

func test_reset() -> void:
	assert_bool(QuestSystem.is_quest_in_pool(_quest, &"TestPool")).is_true()
	pool.reset()
	assert_array(pool.quests).contains_same_exactly([])
