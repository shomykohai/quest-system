extends Node

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
		available = pool.new("Available")
	if active.get_script().resource_path != QuestSystemSettings.get_config_setting("active_quest_pool_path", active.get_script().resource_path):
		var pool := load(QuestSystemSettings.get_config_setting("active_quest_pool_path"))
		active = pool.new("Active")
	if completed.get_script().resource_path != QuestSystemSettings.get_config_setting("completed_quest_pool_path", completed.get_script().resource_path):
		var pool := load(QuestSystemSettings.get_config_setting("completed_quest_pool_path"))
		completed = pool.new("Completed")

	add_child(available)
	add_child(active)
	add_child(completed)

	for pool_path in ProjectSettings.get_setting("quest_system/config/additional_pools", []):
		var pool_name: String = pool_path.get_file().split(".")[0].to_pascal_case()
		add_new_pool(pool_path, pool_name)

#region: Quest API

func start_quest(quest: Quest, args: Dictionary = {}) -> Quest:
	assert(quest != null)

	if active.is_quest_inside(quest):
		return quest
	if completed.is_quest_inside(quest): #Throw an error?
		return quest

	#Add the quest to the actives quests
	available.remove_quest(quest)
	active.add_quest(quest)
	quest_accepted.emit(quest)

	quest.start(args)

	return quest


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


func mark_quest_as_available(quest: Quest) -> void:
	if available.is_quest_inside(quest) or completed.is_quest_inside(quest) or active.is_quest_inside(quest):
		return

	available.add_quest(quest)
	new_available_quest.emit(quest)


func get_available_quests() -> Array[Quest]:
	return available.quests

func get_active_quests() -> Array[Quest]:
	return active.quests


func is_quest_available(quest: Quest) -> bool:
	if not (active.is_quest_inside(quest) or completed.is_quest_inside(quest)):
		return true
	return false

func is_quest_active(quest: Quest) -> bool:
	if active.is_quest_inside(quest):
		return true
	return false

func is_quest_completed(quest: Quest) -> bool:
	if completed.is_quest_inside(quest):
		return true
	return false

func is_quest_in_pool(quest: Quest, pool_name: String) -> bool:
	if pool_name.is_empty():
		for pool in get_children():
			if pool.is_quest_inside(quest): return true
		return false

	var pool := get_node(pool_name)
	if pool.is_quest_inside(quest): return true
	return false


func call_quest_method(quest_id: int, method: String, args: Array) -> void:
	var quest: Quest = null

	# Find the quest if present
	for pools in get_children():
		if pools.get_quest_from_id(quest_id) != null:
			quest = pools.get_quest_from_id(quest_id)
			break

	# Make sure we've got the quest
	if quest == null: return

	if quest.has_method(method):
		quest.callv(method, args)


func set_quest_property(quest_id: int, property: String, value: Variant) -> void:
	
	# Find the quest
	var quest: Quest = _get_quest_by_id(quest_id)

	if quest == null: return

	# Now check if the quest has the property
	if not _quest_has_property(quest, property): return

	# Finally we set the value
	quest.set(property, value)

func get_quest_property(quest_id: int, property: String) -> Variant:
	
	# Find the quest
	var quest: Quest = _get_quest_by_id(quest_id)

	if quest == null: return null

	# Now check if the quest has the property
	if not _quest_has_property(quest, property): return null

	# Finally we get the value
	return quest.get(property)

func _quest_has_property(quest: Quest, property: String) -> bool:
	# If the property is null -> we return
	if property == null: return false

	var was_property_found: bool = false
	# Then we check if the property is present
	for p in quest.get_property_list():
		if p.name == property:
			was_property_found = true
			break
			
	return was_property_found

func _get_quest_by_id(quest_id: int) -> Quest:
	var quest: Quest = null

	# Find the quest
	for pools in get_all_pools():
		if pools.get_quest_from_id(quest_id) != null:
			quest = pools.get_quest_from_id(quest_id)
			
	return quest

#endregion
#region: Manager API

func add_new_pool(pool_path: String, pool_name: String) -> void:
	var pool = load(pool_path)
	if pool == null: return

	var pool_instance = pool.new(pool_name)

	# Make sure the pool does not exist yet
	for pools in get_children():
		if pool_instance.get_script() == pools.get_script():
			return

	add_child(pool_instance)


func get_pool(pool: String) -> BaseQuestPool:
	return get_node_or_null(pool)


func get_all_pools() -> Array[BaseQuestPool]:
	var pools: Array[BaseQuestPool] = []
	for child in get_children():
		if child is BaseQuestPool:
			pools.append(child)
	return pools


func move_quest_to_pool(quest: Quest, old_pool: String, new_pool: String) -> Quest:
	if old_pool == new_pool: return

	var old_pool_instance: BaseQuestPool = get_node_or_null(old_pool)
	var new_pool_instance: BaseQuestPool = get_node_or_null(new_pool)

	assert(old_pool_instance != null or new_pool_instance != null)

	old_pool_instance.remove_quest(quest)
	new_pool_instance.add_quest(quest)

	return quest


func reset_pool(pool_name: String) -> void:
	if pool_name.is_empty():
		for pool in get_children():
			pool.reset()
		return

	var pool := get_node(pool_name)
	pool.reset()
	return


func quests_as_dict() -> Dictionary:
	var quest_dict: Dictionary = {}

	for pool in get_all_pools():
		quest_dict[pool.name.to_lower()] = pool.get_ids_from_quests()

	return quest_dict


func dict_to_quests(dict: Dictionary, quests: Array[Quest]) -> void:
	for pool in get_children():

		# Make sure to iterate only for available pools
		if !dict.has(pool.name.to_lower()): continue

		# Match quest with their ids and insert them into the quest pool
		var quest_with_id: Dictionary = {}
		var pool_ids: Array[int]
		pool_ids.append_array(dict[pool.name.to_lower()])
		for quest in quests:
			if quest.id in pool_ids:
				pool.add_quest(quest)
				quests.erase(quest)


func serialize_quests(pool: String = "") -> Dictionary:
	var _quests: Array[Quest]
	if pool.is_empty():
		for _pool in get_all_pools():
			_quests.append_array(_pool.get_all_quests())
	else:
		var _pool := get_pool(pool)
		if _pool == null: return {}
		_quests.append_array(_pool.get_all_quests())

	var quest_dictionary: Dictionary = {}
	for quest in _quests:
		var quest_data: Dictionary
		quest_data = quest.serialize()
		quest_dictionary[str(quest.id)] = quest_data

	return quest_dictionary


func deserialize_quests(data: Dictionary, pool: String = "") -> Error:
	var _quests: Array[Quest]
	if pool.is_empty():
		for _pool in get_all_pools():
			_quests.append_array(_pool.get_all_quests())
	else:
		var _pool := get_pool(pool)
		if _pool == null: return ERR_DOES_NOT_EXIST
		_quests.append_array(_pool.get_all_quests())

	for quest in _quests:
		quest.deserialize(data.get(str(quest.id), {}))

	return OK

#endregion
