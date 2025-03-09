extends AbstractQuestManagerAPI
class_name QuestSystemManagerAPI
## An implementation of the QuestManager API that uses the default pools.[br]
##
## Here, AvailablePool, ActivePool and CompletedPool are used by default,
## with methods specific to these pools.[br]
##
## You can extend this class to create your own custom manager based on this one.


signal quest_accepted(quest: Quest) # Emitted when a quest gets moved to the ActivePool
signal quest_completed(quest: Quest) # Emitted when a quest gets moved to the CompletedPool
signal new_available_quest(quest: Quest) # Emitted when a quest gets added to the AvailablePool

const AvailableQuestPool = preload("./available_pool.gd")
const ActiveQuestPool = preload("./active_pool.gd")
const CompletedQuestPool = preload("./completed_pool.gd")


var available: AvailableQuestPool = AvailableQuestPool.new("Available")
var active: ActiveQuestPool = ActiveQuestPool.new("Active")
var completed: CompletedQuestPool = CompletedQuestPool.new("Completed")


func _init() -> void:
	# Ovverride default pools if specified in project settings.
	if available.get_script().resource_path != QuestSystemSettings.get_config_setting("available_quest_pool_path", available.get_script().resource_path):
		var pool := load(QuestSystemSettings.get_config_setting("available_quest_pool_path"))
		available.queue_free()
		available = pool.new("Available")
	if active.get_script().resource_path != QuestSystemSettings.get_config_setting("active_quest_pool_path", active.get_script().resource_path):
		var pool := load(QuestSystemSettings.get_config_setting("active_quest_pool_path"))
		active.queue_free()
		active = pool.new("Active")
	if completed.get_script().resource_path != QuestSystemSettings.get_config_setting("completed_quest_pool_path", completed.get_script().resource_path):
		var pool := load(QuestSystemSettings.get_config_setting("completed_quest_pool_path"))
		completed.queue_free()
		completed = pool.new("Completed")

	add_child(available)
	add_child(active)
	add_child(completed)

	# Call the super constructor
	super()



#region: Quest API


## Start a given quest, and add it to the active pool
func start_quest(quest: Quest, args: Dictionary = {}) -> Quest:
	assert(quest != null)

	if active.is_quest_inside(quest):
		return quest
	if completed.is_quest_inside(quest) or QuestSystemSettings.get_config_setting("allow_repeating_completed_quests", false):
		return quest

	#Add the quest to the actives quests
	available.remove_quest(quest)
	active.add_quest(quest)
	quest_accepted.emit(quest)

	quest.start(args)

	return quest


## Complete a given quest, and add it to the completed pool.[br]
## Additionally, if the [objective_completed] property of the quest 
##is not set to true when the complete() method gets called, 
## it will not mark the quest as completed and instead return back the quest object.[br]
##
## You can ovverride this behavior by setting the "require_objective_completed" in the ProjectSettings to false
func complete_quest(quest: Quest, args: Dictionary = {}) -> Quest:
	if not active.is_quest_inside(quest):
		return quest

	if quest.objective_completed == false and QuestSystemSettings.get_config_setting("require_objective_completed"):
		return quest

	quest.complete(args)

	active.remove_quest(quest)
	completed.add_quest(quest)

	quest_completed.emit(quest)

	return quest


## Calls the update() method on the given quest
func update_quest(quest: Quest, args: Dictionary = {}) -> Quest:
	var pool_with_quest: BaseQuestPool = null

	for pool in get_all_pools():
		if pool.is_quest_inside(quest):
			pool_with_quest = pool
			break

	if pool_with_quest == null:
		push_warning("Tried calling update on a Quest that is not in any pool.")
		return quest

	quest.update(args)

	return quest


## Marks a given quest as available (Adds it to the available pool)
func mark_quest_as_available(quest: Quest) -> void:
	if available.is_quest_inside(quest) or completed.is_quest_inside(quest) or active.is_quest_inside(quest):
		return

	available.add_quest(quest)
	new_available_quest.emit(quest)


## Returns all the available quests (quests in the available pool)
func get_available_quests() -> Array[Quest]:
	return available.get_all_quests()


## Returns all the active quests (quests in the active pool)
func get_active_quests() -> Array[Quest]:
	return active.get_all_quests()


## Returns true if the given quest is inside the available pool,
## false otherwise
func is_quest_available(quest: Quest) -> bool:
	if available.is_quest_inside(quest):
		return true
	return false


## Returns true if the given quest is inside the active pool,
## false otherwise
func is_quest_active(quest: Quest) -> bool:
	if active.is_quest_inside(quest):
		return true
	return false


## Returns true if the given quest is inside the completed pool,
## false otherwise
func is_quest_completed(quest: Quest) -> bool:
	if completed.is_quest_inside(quest):
		return true
	return false

#endregion
