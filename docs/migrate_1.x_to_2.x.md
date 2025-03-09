# Migrate from v1.x to 2.x

In version 2.x, the QuestSystem had some changes in the API. This is due to Godot 4.4 internal changes.

NOTE: **In order to update to version 2.x, you must have Godot 4.4 or higher installed. QuestSystem won't prompt a new update if you have Godot 4.3 or less**

Here's how to fix all the errors you may encounter.

## dict_to_quests

The dict_to_quests method is now called `restore_pool_state_from_dict`. 

Just replace the function call in your code.

## quests_as_dict

The quests_as_dict method is now called `pool_state_as_dict`.
