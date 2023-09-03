extends Node
class_name BaseQuestPool

var quests: Array[Quest] = []


func _init(pool_name: String) -> void:
	self.set_name(pool_name)


func add_quest(quest: Quest) -> Quest:
	assert(quest != null)

	quests.append(quest)

	return quest

func remove_quest(quest: Quest) -> Quest:
	assert(quest != null)

	quests.erase(quest)

	return quest

func get_quest_from_id(id: int) -> Quest:
	for quest in quests:
		if quest.id == id:
			return quest
	return null

func is_quest_inside(quest: Quest) -> bool:
	return quest in quests
