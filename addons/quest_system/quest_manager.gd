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
	add_child(available)
	add_child(active)
	add_child(completed)


# Quest API


func start_quest(quest: Quest) -> Quest:
	assert(quest != null)

	if active.is_quest_inside(quest):
		return quest
	if completed.is_quest_inside(quest): #Throw an error?
		return quest

	#Add the quest to the actives quests
	available.remove_quest(quest)
	active.add_quest(quest)
	quest_accepted.emit(quest)

	quest.start()

	return quest


func complete_quest(quest: Quest) -> Quest:
	if not active.is_quest_inside(quest):
		return quest

	if quest.objective_completed == false:
		return quest

	quest.complete()

	active.remove_quest(quest)
	completed.add_quest(quest)

	quest_completed.emit(quest)

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
	var quest: Quest = null

	# Find the quest
	for pools in get_children():
		if pools.get_quest_from_id(quest_id) != null:
			quest = pools.get_quest_from_id(quest_id)

	if quest == null: return

	# Now check if the quest has the property

	# First if the property is null -> we return
	if property == null: return

	var was_property_found: bool = false
	# Then we check if the property is present
	for p in quest.get_property_list():
		if p.name == property:
			was_property_found = true
			break

	# Return if the property was not found
	if not was_property_found: return

	# Finally we set the value
	quest.set(property, value)

# Manager API

func add_new_pool(pool_path: String, pool_name: String) -> void:
	var pool = load(pool_path)
	if pool == null: return

	var pool_instance = pool.new(pool_name)

	# Make sure the pool does not exist yet
	for pools in get_children():
		if pool_instance.get_script() == pools.get_script():
			return

	add_child(pool_instance)


func move_quest_to_pool(quest: Quest, old_pool: String, new_pool: String) -> Quest:
	if old_pool == new_pool: return

	var old_pool_instance: BaseQuestPool = get_node_or_null(old_pool)
	var new_pool_instance: BaseQuestPool = get_node_or_null(new_pool)

	assert(old_pool_instance != null or new_pool_instance != null)

	old_pool_instance.quests.erase(quest)
	new_pool_instance.quests.append(quest)

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

	for pool in get_children():
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


func serialize_quests(pool: String) -> Dictionary:
	var pool_node: BaseQuestPool = get_node_or_null(pool)

	if pool_node == null: return {}

	var quest_dictionary: Dictionary = {}
	for quests in pool_node.quests:
		var quest_data: Dictionary
		for name in quests.get_script().get_script_property_list():

			# Filter only defined properties
			if name.usage & PROPERTY_USAGE_STORAGE or name.usage & PROPERTY_USAGE_SCRIPT_VARIABLE:
				quest_data[name["name"]] = quests.get(name["name"])

		quest_data.erase("id")
		quest_dictionary[quests.id] = quest_data

	return quest_dictionary















