## Extending Quest Manager

QuestSystem allows to extend the autoload if you want to add your own logic to the quest manager, or just change how things works.<br>

By default, QuestSystem ships with a fully working quest manager autoload, but it might be limited for some users. Here you can learn how to extend it to your needs.

## Understaing the difference between `QuestSystem` and `QuestManager`

When we refer to `QuestSystem` in the code, we're calling the autoload, which is part of the scene tree.<br>
When we refer to `QuestManager`, we're referring to the class that implements all the logic of the autoload.<br>

Even if they might be the same, you can have different implementation of QuestManager, but only one of them will become the `QuestSystem` autoload instance when running your game.<br>

To use the addon in your code, you *must* call `QuestSystem.whatever_method_you_want()`, because QuestSystem is an instance of the QuestManager class you chose.<br>
So, avoid calling `MyQuestManagerClass.whatever()`, as this might result in an error unless the method is static.<br>

## Difference between `AbstractQuestManagerAPI` and `QuestSystemManagerAPI`

The `AbstractQuestManagerAPI` is the base class for all quest managers, and it contains general methods that are used by a manager. It does not contain any pool, but has the needed method to instanciate them. Don't use this as your autoload script as it will not work.<br>

The `QuestSystemManagerAPI` is the default manager that comes with the addon, and it contains methods to handle the Active, Available and Completed pools.<br>


Depending on whether you want to tweak the default manager or create your own, you can choose to extend either of them.<br>


## Extending the QuestSystemManagerAPI

If you want to extend the default manager, you can do so by creating a new script that extends `QuestSystemManagerAPI`.<br>

```gdscript
extends QuestSystemManagerAPI
class_name MyQuestManager

```

You can now override any method you want or add your own methods.<br>

```gdscript
extends QuestSystemManagerAPI
class_name MyQuestManager

var failed: BaseQuestPool = null

func _ready() -> void:
    add_pool("res://addons/quest_system/base_quest_pool.gd", "Failed")

    super() # Call the parent _ready method to initialize the other pools


# New method to handle failed quests
func fail_quest(quest: Quest) -> Quest:
    if completed.is_quest_inside(quest):
        return

    # Quest already failed
    if failed.is_quest_inside(quest):
        return
    
    # The quest needs to be active to be failed
    if not active.is_quest_inside(quest):
        return

    move_quest(quest, "Active", "Failed")

    return quest


# Override default method to complete the quest
func complete_quest(quest: Quest, args: Dictionary = {}) -> Quest:
    if failed.is_quest_inside(quest):
        return

    # Call the parent method to complete the quest
    return super()

```

Then set the new script in ProjectSettings -> QuestSystem -> Autoload path<br>

## Extending the AbstractQuestManagerAPI

If you want to completely customize how the quest manager works, you can extend the `AbstractQuestManagerAPI` class to have more control over the autoload.<br>

```gdscript
extends AbstractQuestManagerAPI
class_name MyNewQuestManager

var active: ActiveQuestPool = null
var completed: CompletedQuestPool = null

var quests: Dictionary[int, Quest] = {}

func _ready() -> void:
    active = ActiveQuestPool.new("Active")
    completed = CompletedQuestPool.new("Completed")

    add_child(active)
    add_child(completed)

    # Load the quests before hand so we always have a reference to them

    for quest in DirAccess.get_files_at("res://quests/"):
        var quest_path = "res://quests/" + quest
        var quest_resource = load(quest_path)
        if quest_resource is Quest:
            quests[quest_resource.id] = quest_resource
    


# We declare a new method to start a quest, which requires the ID instead of the resource
func start_quest(id: int, args: Dictionary = {}) -> Quest:
    if not id in quests.keys():
        return null
    
    if not completed.is_quest_inside(quests[id]):
        return null

    var quest = quests[id]
    active.add_quest(quest)
    quest.start(args)
    return quest


func complete_quest(id: int, args: Dictionary = {}) -> Quest:
    if not id in quests.keys():
        return null

    if not active.is_quest_inside(quests[id]):
        return null

    
    var quest = quests[id]
    active.remove_quest(quest)
    completed.add_quest(quest)
    quest.complete(args)

    return quest


func get_quest(id: int) -> Quest:
    if not id in quests.keys():
        return null

    return quests[id]
```


Extending the `AbstractQuestManagerAPI` is a bit more complex, as you need to implement all the methods that are required by the autoload, but it's more flexible, especially when integrating with other addons, such as Pandora:


```gdscript
extends AbstractQuestManagerAPI
class_name PandoraQuestManager

var active: ActiveQuestPool = null
var completed: CompletedQuestPool = null

var quests: Dictionary[int, PandoraQuest] = {}


func _ready() -> void:
    active = ActiveQuestPool.new("Active")
    completed = CompletedQuestPool.new("Completed")

    add_child(active)
    add_child(completed)


    # Load the quests from Pandora
    # This assumes you have category generation enabled in Pandora
    for p_quest in Pandora.get_all_entities(PandoraCategories.QUESTS):
        qyuests[p_quest.get_id()] = p_quest



... # Implementation of all the methods based on the new way of loading quests
```