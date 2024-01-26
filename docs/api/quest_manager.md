# QuestSystem API

## `QuestSystem`

### Description

The `QuestSystem` class is the main entrypoint to the Quest API.<br>
It handles all the [quest pools] and also provide helpers to add more pools or manage your quest resource.<br>

### Properties

| Name           | Type        | Description |
| ---------------| ------------| ------------| 
| `available`    | [AvailableQuestPool](#availablequestpool)| Reference to the default "available pool" |
| `active`    | [ActiveQuestPool](#activequestpool)| Reference to the default "active pool" |
| `completed`    | [CompletedQuestPool](#completedquestpool)| Reference to the default "completed pool" |

### Methods

| Name | Return Type |
| ---- | ----------- |
| [**start_quest**](#quest-start_questquest-quest)**(quest:** [Quest](#quest)**)** | [Quest](#quest) |
| [**complete_quest**](#quest-complete_questquest-quest)**(quest:** [Quest](#quest)**)** | [Quest](#quest) |
| [**mark_quest_as_available**](#void-mark_quest_as_availablequest-quest)**(quest:** [Quest](#quest)**)** | **void** |
| [**get_available_quests**](#arrayquest-get_available_quests)**()** | [Array](https://docs.godotengine.org/en/stable/classes/class_array.html)**[**[Quest](#quest)**]** |
| [**get_active_quests**](#arrayquest-get_active_quests)**()** | [Array](https://docs.godotengine.org/en/stable/classes/class_array.html)**[**[Quest](#quest)**]** |
| [**is_quest_available**](#bool-is_quest_availablequest-quest)**(quest:** [Quest](#quest)**)** | [bool](https://docs.godotengine.org/en/stable/classes/class_bool.html) |
| [**is_quest_active**](#bool-is_quest_activequest-quest)**(quest:** [Quest](#quest)**)** | [bool](https://docs.godotengine.org/en/stable/classes/class_bool.html) |
| [**is_quest_completed**](#bool-is_quest_completedquest-quest)**(quest:** [Quest](#quest)**)** | [bool](https://docs.godotengine.org/en/stable/classes/class_bool.html) |
| [**call_quest_method**](#void-call_quest_methodquest_id-int-method-string--args-array)**(quest_id:** [int](https://docs.godotengine.org/en/stable/classes/class_int.html), **method:** [String](https://docs.godotengine.org/en/stable/classes/class_string.html),  **args:** [Array](https://docs.godotengine.org/en/stable/classes/class_array.html)**)** | **void** |
| [**add_new_pool**](#void-add_new_poolpool_path-string-pool_name-string)**(pool_path:** [String](https://docs.godotengine.org/en/stable/classes/class_string.html), **pool_name:** [String](https://docs.godotengine.org/en/stable/classes/class_string.html)**)** | **void** |
| [**move_quest_to_pool**](#quest-move_quest_to_poolquest-quest-old_pool-string-new_pool-string)**(quest:** [Quest](#quest), **old_pool:** [String](https://docs.godotengine.org/en/stable/classes/class_string.html), **new_pool:** [String](https://docs.godotengine.org/en/stable/classes/class_string.html)**)** | [Quest](#quest) |
| [**quests_as_dict**](#dictionary-quests_as_dict)**()** | [Dictionary](https://docs.godotengine.org/en/stable/classes/class_dictionary.html) |
| [**dict_to_quests**](#void-dict_to_questsdict-dictionary-quests-arrayquest)**(dict:** [Dictionary](https://docs.godotengine.org/en/stable/classes/class_dictionary.html), **quests:** [Array](https://docs.godotengine.org/en/stable/classes/class_array.html)**[**[Quest](#quest)**])** | **void** |
| [**serialize_quests**](#dictionary-serialize_questspool-string)**(pool:** [String](https://docs.godotengine.org/en/stable/classes/class_string.html)**)** | [Dictionary](https://docs.godotengine.org/en/stable/classes/class_dictionary.html) |

### Signals
| signal | description |
| ------ | ----------- |
| quest_accepted(quest: [Quest](#quest)) | Emitted when a quest gets moved to the ActivePool |
| quest_completed(quest: [Quest](#quest)) | Emitted when a quest gets moved to the CompletedPool |
| new_available_quest(quest: [Quest](#quest)) | Emitted when a quest gets added to the AvailablePool |

--------------
#### _[Quest](#quest)_ **start_quest(quest:** [Quest](#quest)**)**
> Starts a given quest by calling its [start()]() method and moving it from the available pool to the active pool.<br><br>
> Can be called even if the quest is not in the available pool.<br>
> If the quest is already in the active pool or in the complete pool, it won't do nothing and returns back the quest.<br><br>
> It also emits the [quest_accepted signal](#signals)

#### _[Quest](#quest)_ **complete_quest(quest:** [Quest](#quest)**)**
> Stops a given quest by calling its [complete()]() method and moving it from the active pool to the completed pool.<br><br>
> If the quest is not in the active pool, it won't do nothing and returns back the quest.<br><br>
>
> **If the [objective_completed]() property of the quest is not set to true when the complete() method gets called, it will not mark the quest as completed and instead return back the quest object.**
>
> It also emits the [quest_completed signal](#signals)

#### _void_ **mark_quest_as_available(quest:** [Quest](#quest)**)**
> Adds a quest to the available pool if not already present in any of the [default pools](#properties)<br>
> It also emits the [new_available_quest signal](#signals)

#### _[Array](https://docs.godotengine.org/en/stable/classes/class_array.html)**[**[Quest](#quest)**]**_ **get_available_quests()**
> Returns all quests in the available pool

#### _[Array](https://docs.godotengine.org/en/stable/classes/class_array.html)**[**[Quest](#quest)**]**_ **get_active_quests()**
> Returns all quests in the active pool

#### _[bool](https://docs.godotengine.org/en/stable/classes/class_bool.html)_ **is_quest_available(quest:** [Quest](#quest)**)**
> Checks if the given quest is inside the avaiable pool. Returns `true` if the quest is found.

#### _[bool](https://docs.godotengine.org/en/stable/classes/class_bool.html)_ **is_quest_active(quest:** [Quest](#quest)**)**
> Checks if the given quest is inside the active pool. Returns `true` if the quest is found.

#### _[bool](https://docs.godotengine.org/en/stable/classes/class_bool.html)_ **is_quest_completed(quest:** [Quest](#quest)**)**
> Checks if the given quest is inside the completed pool. Returns `true` if the quest is found.

#### _void_ **call_quest_method(quest_id:** [int](https://docs.godotengine.org/en/stable/classes/class_int.html), **method:** [String](https://docs.godotengine.org/en/stable/classes/class_string.html),  **args:** [Array](https://docs.godotengine.org/en/stable/classes/class_array.html)**)**
> Calls any given method inside a specific quest without the need to have a direct reference to the Quest Resource.<br>
> You will need to provide the ID of the quest and the method name.<br>
> You can also provide additional arguments to the function.<br>
> If the quest is not found, it won't do anything.
> Internally the [`callv`](https://docs.godotengine.org/it/stable/classes/class_object.html#class-object-method-callv) function gets used

#### _void_ **add_new_pool(pool_path:** [String](https://docs.godotengine.org/en/stable/classes/class_string.html), **pool_name:** [String](https://docs.godotengine.org/en/stable/classes/class_string.html)**)**
> Adds a custom quest pool.<br>
> You'll need to reference the path of a Script that inherits [BaseQuestPool]() for `pool_path` and give the pool a name.

#### _[Quest](#quest)_ **move_quest_to_pool(quest:** [Quest](#quest), **old_pool:** [String](https://docs.godotengine.org/en/stable/classes/class_string.html), **new_pool:** [String](https://docs.godotengine.org/en/stable/classes/class_string.html)**)**
> Forcefully move a quest from a pool to another

#### _[Dictionary](https://docs.godotengine.org/en/stable/classes/class_dictionary.html)_ **quests_as_dict()**
> Returns a dictionary with all the quest pools and their respectively quests referenced by their id.
> ```json
> {
>    "available": [5],
>    "active": [1, 2, 3],
>    "completed": [4],
> }
> ```
>
#### _void_ **dict_to_quests(dict:** [Dictionary](https://docs.godotengine.org/en/stable/classes/class_dictionary.html), **quests:** [Array](https://docs.godotengine.org/en/stable/classes/class_array.html)**[**[Quest](#quest)**])**
> Loads back into the pools the given quest resources based on a dictionary as the one that [quest_as_dict()](#dictionary-quests_as_dict) returns.<br>
> If a pool in the dictionary is not present in the QuestSystem children, it gets skipped.

#### _[Dictionary](https://docs.godotengine.org/en/stable/classes/class_dictionary.html)_ **serialize_quests(pool:** [String](https://docs.godotengine.org/en/stable/classes/class_string.html)**)**
> Serialize all the properties of the quests of a pool and returns them as a dictionary.<br>
> ```json
> { 
>    "1": 
>    { 
>          "quest_name": "Test Quest",
>          "quest_description": "This is the description of the test quest.",
>          "quest_objective": "Nothing.",
>          "objective_completed": false
>    }
> }
> ```
>
> If a quest has custom properties they will also get serialized.
--------------

## `Quest`

### Description

Base class for all Quest resources.<br>
By itself it does nothing other than provide a simple API to make quests.<br><br>

To make a custom quest make a script that inherits `Quest` and implement your own logic, then create a Resource of the type of your custom quest.<br>
**Note: you should implement the start() and complete() methods and set the `objective_completed` property to true to make the quest completable.**



### Properties

(These are the default properties that every quest resource share. You can add your custom properties in a custom quest resource.)

| Name           | Type        | Description |
| ---------------| ------------| ------------|
| `id`           | [int](https://docs.godotengine.org/en/stable/classes/class_int.html) | Unique Identifier for a quest |
| `quest_name`   | [String](https://docs.godotengine.org/en/stable/classes/class_string.html) | The name of a quest |
| `quest_description` | [String](https://docs.godotengine.org/en/stable/classes/class_string.html) | Description of the quest |
| `quest_objective` | [String](https://docs.godotengine.org/en/stable/classes/class_string.html) | Description of the objective of the quest |
| `objective_completed` **_= false_** | [bool](https://docs.godotengine.org/en/stable/classes/class_bool.html) | Tracks the progress of the quest.<br>If it's false, the quest can't be moved to the CompletedPool | 

### Methods

| Name | Return Type |
| ---- | ----------- |
| [**start**](#void-start)**()** | **void** |
| [**complete**](#void-complete)**()** | **void |

--------------

#### _void_ **start()**
> Gets called after [start_quest](#quest-start_questquest-quest) 
#### _void_ **complete()**
> Gets called after [complete_quest](#quest-complete_questquest-quest) only if `objective_completed` is set to `true`

--------------

## `BaseQuestPool`**(_pool_name:_** [`String`](https://docs.godotengine.org/en/stable/classes/class_string.html)**)**

### Description

Base class for all quest pools.<br>
Inherit this class to make a custom pool with your own logic.<br>
You need to pass a name to give to the pool in the constructor of the class.

### Properties

| Name | Type | Description |
| ---- | ---- | ----------- |
| quests | [Array](https://docs.godotengine.org/en/stable/classes/class_array.html)**[**[Quest](#quest)**]** | An array of all the quests in the pool |


### Methods

| Name | Return Type |
| ---- | ----------- |
| [**add_quest**](#quest-add_questquest-quest)**(quest:** [Quest](#quest)**)** | [Quest](#quest) |
| [**remove_quest**](#quest-remove_questquest-quest)**(quest:** [Quest](#quest)**)** | [Quest](#quest) |
| [**get_quest_from_id**](#quest-get_quest_from_idid-int)**(id:** [int](https://docs.godotengine.org/en/stable/classes/class_int.html)**)** | [Quest](#quest) |
| [**is_quest_inside**](#bool-is_quest_insidequest-quest)**(quest:** [Quest](#quest)**)** | [bool](https://docs.godotengine.org/en/stable/classes/class_bool.html) |

--------------

#### _[Quest](#quest)_ **add_quest(quest:** [Quest](#quest)**)**
> Adds a quest resource into the quests array
#### _[Quest](#quest)_ **remove_quest(quest:** [Quest](#quest)**)**
> Removes a quest resource into the quests array
#### _[Quest](#quest)_ **get_quest_from_id(id:** [int](https://docs.godotengine.org/en/stable/classes/class_int.html)**)**
> Returns a quest with the corresponding id.<br>
> If no quest gets found, `null` is returned instead
#### _[bool](https://docs.godotengine.org/en/stable/classes/class_bool.html)_ **is_quest_inside(quest:** [Quest](#quest)**)**
> Returns `true` if a given quest is inside the pool.

--------------

## `AvailableQuestPool`

### Description

Container for all available quests.
Inherits [BaseQuestPool](#basequestpoolpool_name-string)

--------------

## `ActiveQuestPool`

### Description

Container for all active quests.
Inherits [BaseQuestPool](#basequestpoolpool_name-string)

--------------

## `CompletedQuestPool`

### Description

Container for all completed quests.
Inherits [BaseQuestPool](#basequestpoolpool_name-string)