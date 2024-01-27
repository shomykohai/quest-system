--------------

## `ActiveQuestPool`
**Inherits:** [BaseQuestPool](/api/quest_pool/base_quest_pool.md)
### Description

Container for all active quests.
Quests get inserted into this pool when calling the [start_quest()](/api/quest_manager.md#quest-start_questquest-quest) method.

### Methods

| Name | Return Type |
| ---- | ----------- |
| [**update_objective**](#void-update_objectivequest_id-int)**(quest_id:** [int](https://docs.godotengine.org/en/stable/classes/class_int.html)**)** | **void** |

--------------

#### _void_ **update_objective(quest_id:** [int](https://docs.godotengine.org/en/stable/classes/class_int.html)**)**
> Calls the [update()](/api/quest_resource.md#void-update) method on the requested quest.