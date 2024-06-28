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
## Must be set to true to be able to complete the quest;
## Can be disabled in [code]ProjectSettings -> QuestSystem -> Config -> Require Objective Completed[/code]
var objective_completed: bool = false:
	set(value):
		objective_completed = value
	get:
		return objective_completed


## Gets called after QuesySystem' [method update_quest] method.[br][br]
##
## By default, emits the [signal updated] signal.
func update(_args: Dictionary = {}) -> void:
	updated.emit()


## Gets called after QuesySystem' [method start_quest] method.[br]
## Additional data may be passed from the optional [param _args] parameter.[br][br]
##
## By default, emits the [signal started] signal.
func start(_args: Dictionary = {}) -> void:
	started.emit()


## Gets called after QuesySystem' [method complete_quest] method.[br]
## Make sure to set [member objective_completed] to true or disable its requirement in ProjectSettings,[br]
## or this method won't be called.[br][br]
##
## By default, emits the [signal completed] signal.
func complete(_args: Dictionary = {}) -> void:
	completed.emit()
