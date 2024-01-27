## `BaseQuestPool`**(_pool\_name:_** [`String`](https://docs.godotengine.org/en/stable/classes/class_string.html)**)**
**Inherits:** [Node](https://docs.godotengine.org/en/stable/classes/class_node.html)
### Description

Base class for all quest pools.<br>
Inherit this class to make a custom pool with your own logic.<br>
You need to pass a name to give to the pool in the constructor of the class.



### Properties

| Name | Type | Description |
| ---- | ---- | ----------- |
| quests | [Array](https://docs.godotengine.org/en/stable/classes/class_array.html)**[[Quest](/api/quest_resource.md)]** | An array of all the quests in the pool |


### Methods

| Name | Return Type |
| ---- | ----------- |
| [**add_quest**](#quest-add_questquest-quest)**(quest:** [Quest](/api/quest_resource.md)**)** | [Quest](/api/quest_resource.md) |
| [**remove_quest**](#quest-remove_questquest-quest)**(quest:** [Quest](/api/quest_resource.md)**)** | [Quest](/api/quest_resource.md) |
| [**get_quest_from_id**](#quest-get_quest_from_idid-int)**(id:** [int](https://docs.godotengine.org/en/stable/classes/class_int.html)**)** | [Quest](/api/quest_resource.md) |
| [**is_quest_inside**](#bool-is_quest_insidequest-quest)**(quest:** [Quest](/api/quest_resource.md)**)** | [bool](https://docs.godotengine.org/en/stable/classes/class_bool.html) |
| [**get_ids_from_quests**](#arrayint-get_ids_from_quests)**()** | [Array](https://docs.godotengine.org/en/stable/classes/class_array.html)**[[int](https://docs.godotengine.org/en/stable/classes/class_int.html)]** |
| [**reset**](#void-reset)**()** | **void** |

--------------

#### _[Quest](/api/quest_resource.md)_ **add_quest(quest:** [Quest](/api/quest_resource.md)**)**
> Adds a quest resource into the quests array
#### _[Quest](/api/quest_resource.md)_ **remove_quest(quest:** [Quest](/api/quest_resource.md)**)**
> Removes a quest resource into the quests array
#### _[Quest](/api/quest_resource.md)_ **get_quest_from_id(id:** [int](https://docs.godotengine.org/en/stable/classes/class_int.html)**)**
> Returns a quest with the corresponding id.<br>
> If no quest is found, `null` is returned instead
#### _[bool](https://docs.godotengine.org/en/stable/classes/class_bool.html)_ **is_quest_inside(quest:** [Quest](/api/quest_resource.md)**)**
> Returns `true` if a given quest is inside the pool.
#### _[Array](https://docs.godotengine.org/en/stable/classes/class_array.html)**[[int](https://docs.godotengine.org/en/stable/classes/class_int.html)]**_ **get_ids_from_quests()**
> Returns an Array that contains the ID of each quest inside the pool.
#### _**void**_ **reset()**
> Resets the quest pool by clearing the [quests](#properties) array.