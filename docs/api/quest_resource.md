--------------

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
| `id`           | [int](https://docs.godotengine.org/en/stable/classes/class_int.html) | Unique Identifier for a quest |
| `quest_name`   | [String](https://docs.godotengine.org/en/stable/classes/class_string.html) | The name of a quest |
| `quest_description` | [String](https://docs.godotengine.org/en/stable/classes/class_string.html) | Description of the quest |
| `quest_objective` | [String](https://docs.godotengine.org/en/stable/classes/class_string.html) | Description of the objective of the quest |
| `objective_completed` **_= false_** | [bool](https://docs.godotengine.org/en/stable/classes/class_bool.html) | Tracks the progress of the quest.<br>If it's false, the quest can't be moved to the CompletedPool | 

### Methods

| Name | Return Type |
| ---- | ----------- |
| [**start**](#void-start)**()** | **void** |
| [**complete**](#void-complete)**()** | **void** |
| [**update**](#void-update)**()** | **void** |

--------------

#### _void_ **start()**
> Gets called after [start_quest](#quest-start_questquest-quest) 
#### _void_ **complete()**
> Gets called after [complete_quest](#quest-complete_questquest-quest) only if `objective_completed` is set to `true`
#### _void_ **update()**
> Abstract method to update the quest progress. It is suggested to set `objective_completed` to `true` here.
