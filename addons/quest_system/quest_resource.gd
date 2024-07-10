@icon("./assets/quest_resource.svg")
extends Resource
class_name Quest
## Base class for all Quest resources.
##
## By itself it does nothing other than provide a simple API to make quests.[br]
## To make a custom quest make a script that inherits `Quest` and implement your own logic, then create a Resource of the type of your custom quest.

## Unique Identifier of the quest
@export var id: int
## The name of the quest
@export var quest_name: String
## A brief description of the quest
@export_multiline var quest_description: String
## A brief description that outlines what must be done to complete the quest
@export_multiline var quest_objective: String

## Emitted by default when [method start] gets called.
signal started
## Emitted by default when [method update] gets called.
signal updated
## Emitted by default when [method complete] gets called.
signal completed

## Whether the objective is fulfilled or not.[br]
## Must be set to true to be able to complete the quest;[br]
## This behaviour can be disabled in [code]ProjectSettings -> QuestSystem -> Config -> Require Objective Completed[/code]
var objective_completed: bool = false:
	set(value):
		objective_completed = value
	get:
		return objective_completed


## Gets called after QuesySystem' [method update_quest] method.[br][br]
##
## By default, it emits the [signal updated] signal.
func update(_args: Dictionary = {}) -> void:
	updated.emit()


## Gets called after QuesySystem' [method start_quest] method.[br]
## Additional data may be passed from the optional [param _args] parameter.[br][br]
##
## By default, it emits the [signal started] signal.
func start(_args: Dictionary = {}) -> void:
	started.emit()


## Gets called after QuesySystem' [method complete_quest] method.[br]
## Make sure to set [member objective_completed] to true or disable its requirement in ProjectSettings,[br]
## or this method won't be called.[br][br]
##
## By default, it emits the [signal completed] signal.
func complete(_args: Dictionary = {}) -> void:
	completed.emit()


## Serializes the quest.[br]
## It's suggested to override this in your implementation to have more control over what's serialized.[br][br]
## By default, every variable (excluding [member id]), exported or not, is serialized.
func serialize() -> Dictionary:
	var quest_data: Dictionary
	for name in get_property_list():
		# Filter only defined properties
		if name.usage == PROPERTY_USAGE_SCRIPT_VARIABLE or name.usage == PROPERTY_USAGE_SCRIPT_VARIABLE | PROPERTY_USAGE_STORAGE | PROPERTY_USAGE_EDITOR:
			quest_data[name["name"]] = self.get(name["name"])
	quest_data.erase(&"id")
	return quest_data


## Loads serialized data back into the Quest.[br]
## Normally there's no need to override this method, do it only if you need more control over the
## deserialization process.
func deserialize(data: Dictionary) -> void:
	for key in data.keys():
		set(key, data[key])
