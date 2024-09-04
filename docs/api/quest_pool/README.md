## What is a quest pool?

A quest pool is a collection of quests which states fall into the same category (e.g. completed quests).
When a scene is run, the QuestSystem autoload automatically adds the default pool as its children.

The goal of a quest pool is to distinguish the state of a quest, in a way that it's scalable and reusable.
With this approach a quest does not need to know all the pool that exist, instead the quest manager is the
one that does the job.


## When and how should I create a new pool?

You should create a pool when introducing a new state for your quests.

For example, we want to be able to drop quests making it impossible to the player to start them again.
This is where creating a new quest pool is useful.


* We first create a new script that inherits [BaseQuestPool](/api/quest_pool/base_quest_pool.md)

```gdscript
# dropped_quest_pool.gd

class_name DroppedQuestPool
extends BaseQuestPool
```

* Then we implement our logic/helper methods. In this example we'll implement a drop quest method.

```gdscript
# dropped_quest_pool.gd

class_name DroppedQuestPool
extends BaseQuestPool

func drop_quest(quest_id: int) -> void:
    pass
```

* We'll make that dropped quest can't be started again by first extending the base quest resource 
and add a `dropped` property to it.

```gdscript
# droppable_quest.gd

class_name DroppableQuest
extends Quest

@export var dropped: bool = false
```

* Now we'll make that when trying to start a dropped quest, it won't do anything and also add a drop method.

```gdscript
# droppable_quest.gd

class_name DroppableQuest
extends Quest

@export var dropped: bool = false

func start() -> void:
    if dropped:
        return

    ... # Logic to start the quest

func drop_quest() -> void:
    dropped = true
```

* And now going back to the DroppedQuestPool script, we'll make it that the drop_quest() method calls the drop() method in the quest resource.

```gdscript
# dropped_quest_pool.gd

class_name DroppedQuestPool
extends BaseQuestPool

func drop_quest(quest_id: int) -> void:
    # We first get the quest with its id
    var quest := get_quest_from_id(quest_id)
    
    # Make sure the Quest exists
    if quest == null:
        return
    
    quest.drop()
```


### Override the default add_quest() behaviour in the default pools.

By now the quest can be marked as dropped, but when trying to start them again there's nothing to block it from happening. That's why we would also want to override the default [ActiveQuestPool](/api/quest_pool/active_quest_pool.md). The reason why we override it is because [`start_quest`](/api/quest_manager#quest-start_questquest-quest) calls the add_quest() method of it.

* We first create an override class that inherits our ActiveQuestPool

```gdscript
# active_quest_pool_override.gd

class_name ActiveQuestPoolOverride
extends ActiveQuestPool
```

* And then override the add_quest() method

```gdscript
# active_quest_pool_override.gd

class_name ActiveQuestPoolOverride
extends ActiveQuestPool

func add_quest(quest: Quest) -> Quest:
    # Here we'll check if the quest is in the dropped pool
    if QuestSystem.is_quest_in_pool(quest, "Dropped")
        print("Quest is dropped, skipping.")
        return quest
    
    super(quest) # Calls the parent add_quest()
```


* And finally, we can override the default ActiveQuestPool in the ProjectSettings

![ActiveQuestPool Override](https://github.com/shomykohai/quest-system/blob/main/docs/assets/api/active_quest_pool_override.png?raw=true)


> NOTE: This can also be done through code:

```gdscript
# some_script_that_runs_when_the_game_starts.gd

func some_function(...) -> ...:
    ...

    var active_override := ActiveQuestPoolOverride.new("Active")
    QuestSystem.active.queue_free() 
    QuestSystem.active = active_override

    QuestSystem.add_new_pool("/path/to/dropped_pool/script", "Dropped")

    ...
```

Now when we'll try to start a quest that is dropped, the quest will keep its state.