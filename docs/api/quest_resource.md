## `Quest`
**Inherits:** [Resource](https://docs.godotengine.org/en/stable/classes/class_resource.html)
### Description

Base class for all Quest resources.<br>
By itself it does nothing other than provide a simple API to make quests.<br><br>

To make a custom quest make a script that inherits `Quest` and implement your own logic, then create a Resource of the type of your custom quest.<br>
> [!NOTE] You should implement the start(), complete()  and update() methods and set the `objective_completed` property to true to make the quest completable.



### Properties

(These are the default properties that every quest resource share. You can add your custom properties in a custom quest resource.)

| Name           | Type        | Description |
| ---------------| ------------| ------------|
| `id`           | [int](https://docs.godotengine.org/en/stable/classes/class_int.html) | Unique Identifier for a quest. |
| `quest_name`   | [String](https://docs.godotengine.org/en/stable/classes/class_string.html) | The name of a quest. |
| `quest_description` | [String](https://docs.godotengine.org/en/stable/classes/class_string.html) | Description of the quest. |
| `quest_objective` | [String](https://docs.godotengine.org/en/stable/classes/class_string.html) | Description of the objective of the quest. |
| `objective_completed` **_= false_** | [bool](https://docs.godotengine.org/en/stable/classes/class_bool.html) | Tracks the progress of the quest.<br>If it's false, the quest can't be moved to the CompletedPool.<br><br>When set, it will emit the objective_status_updated(value: bool) signal to indicate a change in the objective completion state. |

### Methods

| Name | Return Type |
| ---- | ----------- |
| [**start**](#void-start_args-dictionary--)**(_args:** [Dictionary](https://docs.godotengine.org/en/stable/classes/class_dictionary.html) = {}**)** | **void** |
| [**complete**](#void-complete_args-dictionary--)**(_args:** [Dictionary](https://docs.godotengine.org/en/stable/classes/class_dictionary.html) = {}**)** | **void** |
| [**update**](#void-update_args-dictionary--)**(_args:** [Dictionary](https://docs.godotengine.org/en/stable/classes/class_dictionary.html) = {}**)** | **void** |
| [**serialize()**](#dictionary-serialize) | [Dictionary](https://docs.godotengine.org/en/stable/classes/class_dictionary.html) |
| [**deserialize**](#void-deserializedata-dictionary)**(data:** [Dictionary](https://docs.godotengine.org/en/stable/classes/class_dictionary.html)**)** | **void** |

#### _void_ **start(_args:** [Dictionary](https://docs.godotengine.org/en/stable/classes/class_dictionary.html) = {}**)**
> Gets called after [start_quest](#quest-start_questquest-quest) 
#### _void_ **complete(_args:** [Dictionary](https://docs.godotengine.org/en/stable/classes/class_dictionary.html) = {}**)**
> Gets called after [complete_quest](#quest-complete_questquest-quest) only if `objective_completed` is set to `true`
#### _void_ **update(_args:** [Dictionary](https://docs.godotengine.org/en/stable/classes/class_dictionary.html) = {}**)**
> Virtual method to update the quest progress. It is suggested to set `objective_completed` to `true` here.
#### _[Dictionary](https://docs.godotengine.org/en/stable/classes/class_dictionary.html)_ **serialize()**
> Serializes the quest.<br>
> It's suggested to override this in your implementation to have more control over what's serialized.<br><br>
> By default, every variable (excluding [id](#properties)), exported or not, is serialized.
#### _void_ **deserialize(data:** [Dictionary](https://docs.godotengine.org/en/stable/classes/class_dictionary.html)**)**
> Loads serialized data back into the Quest.<br>
> Normally there's no need to override this method, do it only if you need more control over the deserialization process.
--------------

### Signals

| signal | description |
| ------ | ----------- |
| started() | Emitted when the `start()` method is invoked |
| updated() | Emitted when the `update()` method is invoked |
| completed() | Emitted when the `complete()` method is invoked |
| objective_status_updated(value: bool) | Emitted when the `objective_completed` bool value is set |

In order to have these called in your own resources that extend `Quest`, remember to call `super.update()` in your `update` implementation, `super.start()` in your `start` implementation and `super.complete()` in your `complete` implementation.

You can also call `emit()` on `started`, `updated` and `completed` signals from your implementation in any of the functions that would require that (for instance if your UI relies on these signals to update itself).
