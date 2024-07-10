extends Node
class_name BaseQuestPool
## Base class for quest pools.
##
## It defines common methods that can be overriden to customize the behaviour of the pool.

## Collection of quests inside of the pool.
var quests: Array[Quest] = []


func _init(pool_name: String) -> void:
	self.set_name(pool_name)


## Inserts the given quest inside of the pool.[br]
## By default, the quest is appended to [member quests]
func add_quest(quest: Quest) -> Quest:
	assert(quest != null)

	quests.append(quest)

	return quest



## Removes a quest from the pool.[br]
## By the pool, the quest is removed from [member quests]
func remove_quest(quest: Quest) -> Quest:
	assert(quest != null)

	quests.erase(quest)

	return quest


## Looks up for a quest based on its ID and returns it.[br]
## If no quest is found, [code]null[/code] is returned instead.[br]
## By default, the quest is searched inside of [member quests].
func get_quest_from_id(id: int) -> Quest:
	for quest in quests:
		if quest.id == id:
			return quest
	return null


## Returns [code]true[/code] if a given quest is inside the pool.
func is_quest_inside(quest: Quest) -> bool:
	return quest in quests


## Returns an Array containing all the IDs of the quests inside of the pool.
func get_ids_from_quests() -> Array[int]:
	var ids: Array[int] = []
	for quest in quests:
		ids.append(quest.id)
	return ids


## Returns all the quest inside the pool.
func get_all_quests() -> Array[Quest]:
	return quests


## Removes all the pools from the pool.
## By default, it clears the [member quests] array.
func reset() -> void:
	quests.clear()
