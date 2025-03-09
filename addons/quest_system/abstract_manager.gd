extends Node
class_name AbstractQuestManagerAPI
## Base class for the Quest Manager.
##
## It defines common methods that are usually required to manage the quest pools,
## but doesn't implement or define any specific fuonctions for specific pools.[br]
##
## By default, QuestSystem ships with 3 pools: [AvailableQuestPool], [ActiveQuestPool] and [CompletedQuestPool].[br]
## You can add additional pools in ProjectSettings -> QuestSystem -> Config -> Additional Pools[br]
##
## By extending this class, you can create a custom manager that fits your needs.
## The default usable implementation of the API is provided in [code]addons/quest_system/quest_manager.gd[/code].

func _init() -> void:
	# Add additional pools declared in ProjectSettings
	for pool_path in ProjectSettings.get_setting("quest_system/config/additional_pools", []):
		var pool_name: String = pool_path.get_file().split(".")[0].to_pascal_case()
		add_new_pool(pool_path, pool_name)


func _exit_tree() -> void:
	for pool in get_all_pools():
		pool.reset()
		pool.queue_free()


## Returns true if the given quest is present in any of the pools
## or the specified pool.
func is_quest_in_pool(quest: Quest, pool_name: String = "") -> bool:
	if pool_name.is_empty():
		for pool in get_all_pools():
			if pool.is_quest_inside(quest): return true
		return false

	var pool := get_node(pool_name)
	if pool.is_quest_inside(quest): return true
	return false


## Calls any given method inside a specific quest without 
## the need to have a direct reference to the Quest Resource.
##
## You will need to provide the ID of the quest, the method name and additional arguments
func call_quest_method(quest_id: int, method: StringName, args: Array = []) -> void:
	# Find the quest if present
	var quest: Quest = _get_quest_by_id(quest_id)

	# Make sure we've got the quest
	if quest == null: return

	if quest.has_method(method):
		quest.callv(method, args)


## Sets any given property inside a specific quest without 
## the need to have a direct reference to the Quest Resource.
func set_quest_property(quest_id: int, property: StringName, value: Variant) -> void:
	# Find the quest
	var quest: Quest = _get_quest_by_id(quest_id)

	if quest == null: return

	# Now check if the quest has the property
	if not _quest_has_property(quest, property): return

	# Finally we set the value
	quest.set(property, value)


## Returns any given property inside a specific quest without 
## the need to have a direct reference to the Quest Resource.
func get_quest_property(quest_id: int, property: StringName) -> Variant:
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
			break

	return quest

#endregion
#region: Manager API


## Add a new pool to the manager
func add_new_pool(pool_path: String, pool_name: StringName) -> void:
	var pool = load(pool_path)
	if pool == null: return

	var pool_instance = pool.new(pool_name)

	# Make sure the pool does not exist yet
	for pools in get_all_pools():
		if pool_instance.get_script() == pools.get_script() && pool_name != pools.name:
			return

	add_child(pool_instance, true)


## Remove a pool from the manager by its name
func remove_pool(pool_name: StringName) -> void:
	var pool := get_pool(pool_name)
	if pool != null:
		pool.queue_free()


## Get a pool by its name
func get_pool(pool: String) -> BaseQuestPool:
	return get_node_or_null(pool)


## Return all the pools currently in the manager
func get_all_pools() -> Array[BaseQuestPool]:
	var pools: Array[BaseQuestPool] = []
	for child in get_children():
		if child is BaseQuestPool:
			pools.append(child)
	return pools


## Move a quest from one pool to another
func move_quest_to_pool(quest: Quest, old_pool: StringName, new_pool: StringName) -> Quest:
	if old_pool == new_pool: return

	var old_pool_instance: BaseQuestPool = get_pool(old_pool)
	var new_pool_instance: BaseQuestPool = get_pool(new_pool)

	assert(old_pool_instance != null or new_pool_instance != null)

	old_pool_instance.remove_quest(quest)
	new_pool_instance.add_quest(quest)

	return quest


## Reset a pool by its name.
## If no pool name is given, all the pools will be reset
func reset_pool(pool_name: StringName = "") -> void:
	if pool_name.is_empty():
		for pool in get_all_pools():
			pool.reset()
		return

	var pool := get_pool(pool_name)
	pool.reset()
	return


## Return the state of the pools as a dictionary[br]
##
## Example:[br]
##	{
##		"available": [1, 2, 3],
##		"active": [4, 5, 6],
##		"completed": [7, 8, 9]
##	}
func quests_as_dict() -> Dictionary:
	var quest_dict: Dictionary = {}

	for pool in get_all_pools():
		quest_dict[pool.name.to_lower()] = pool.get_ids_from_quests()

	return quest_dict



## Restore the state of the pools from a dictionary containing 
## the name of the pool and the ids of the quests.[br]
##
## This only ensure the quests are restored in the correct pool, but 
## it does not load the single quest state. For that use `deserialize_quests`
func dict_to_quests(dict: Dictionary, quests: Array[Quest]) -> void:
	for pool in get_all_pools():

		# Make sure to iterate only for available pools
		if !dict.has(pool.name.to_lower()): continue

		# Match quest with their ids and insert them into the quest pool
		var pool_ids: Array[int]
		
		# This ensure type safety is respected, especially when parsing with JSON,
		# which automatically parses numbers as floats
		# See issue #31
		pool_ids.assign(dict[pool.name.to_lower()])

		for quest in quests:
			if quest.id in pool_ids:
				pool.add_quest(quest)
				quests.erase(quest)


## Serialize the current state of every quest, or of the given pool, 
## and returns it as a Dictionary.
func serialize_quests(pool: StringName = "") -> Dictionary:
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


## Restores the state of each quest of every pool (or the given one ir provided)
func deserialize_quests(data: Dictionary, pool: StringName = "") -> Error:
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
