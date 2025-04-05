# How to save and load quests data with QuestSystem

NOTE: This will only cover QuestSystem 2.0, but the principles are the same for 1.x, just with some difference in some methods name.


## Pre-requisites

First of all, you'll need to have a Save System in place. If you don't have one, you can follow the [Godot documentation](https://docs.godotengine.org/en/stable/tutorials/io/saving_games.html), or find one on GitHub.

## Saving

To save quests data in quest system, you just need to call the `serialize_quests()` method and the `pool_state_as_dict()` method.

```gdscript

func save_game() -> void:
    var save_data = {}
    
    # Your other save logic
    ... 

    # Save only the data of active quests. To serialize all pools, call the method without providing any argument
    # This will return a dictionary like this:
    #   { 
    #       "1": 
    #       { 
    #        "quest_name": "Test Quest",
    #        "quest_description": "This is the description of the test quest.",
    #        "quest_objective": "Nothing.",
    #        "objective_completed": true
    #       },
    #       "2": 
    #       { 
    #        "quest_name": "Test Quest 2",
    #        "quest_description": "How do I save quests??",
    #        "quest_objective": "Save the quests data.",
    #        "objective_completed": false
    #       },
    #       "3": 
    #       { 
    #        "quest_name": "Test Quest 3",
    #        "quest_description": "This quest has more properties.",
    #        "quest_objective": "Save custom exported properties!",
    #        "objective_completed": false,
    #        "custom_property": "This is a string custom property",
    #        "is_learning_quest_system": true
    #       }
    #   }
    var quest_data = QuestSystem.serialize_quests("Active")

    # Save the pools state, which will return a dictionary containing the name of the pools as the keys and an array of IDs (the IDs of the quests in the pool) as the values
    # This will return a dictionary like this:
    # {
    # "active": [1, 2, 3],
    # }

    var pool_state = QuestSystem.pool_state_as_dict()

    save_data["quest_data"] = quest_data
    save_data["pool_state"] = pool_state

    ... # Store your save file
```

## Loading

To load the quests data back, we use the `restore_pool_state_from_dict()` method and the `deserialize_quests()` method.

Loading requires you providing all the quests resources that you want to load, so make sure you have them loaded before calling the `restore_pool_state_from_dict()` method.

```gdscript

func load_game() -> void:
    var save_data = ... # Get your save_data from your save file


    var quests: Array[Quest]

    # Example of loading quests from a directory
    # You can customize how you get the quests resources, for example load it from Pandora, or from a custom resource loader
    for quest in DirAccess.get_files_at("res://quests/"):
        var quest_path = "res://quests/" + quest
        var quest_resource = load(quest_path)
        if quest_resource is Quest:
            quests.append(quest_resource)


    # Load the pool state, which will load the quests based on the pool_state dictionary:
    # if the pool state is: {"active": [1, 2, 3] }
    # quests with ID 1, 2 and 3 will be loaded into the active pool. Other quests not present in the pool state will be discarded from loading.
 
    QuestSystem.restore_pool_state_from_dict(save_data["pool_state"], quests)

    # Load the quests data into the quests
    QuestSystem.deserialize_quests(save_data["quest_data"])

```



