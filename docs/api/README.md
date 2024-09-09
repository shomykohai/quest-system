## What is QuestSystem?

QuestSystem is a simple and extesible quest manager for Godot 4.x

It provides a simple API and some default helpers methods to manage quests for your game.

## How does it work?

* The QuestManager class (The QuestSystem API) gives access to some methods to move, add, remove and manage the quest resources inside of containers called quest pools.

* The autoloaded QuestSystem script adds pools as its children, and you can add custom pools to express more quest states. 

* Quests are godot resources that also implements methods inside of them.
To call a method from a quest you use the API.

* Quests are extensible, thus you can make every kind of quest as long as you implement the start(), update() and complete() methods. The limit is your imagination (and problably some bad design choice that the addon may have. If any, report them [here](https://github.com/shomykohai/quest-system/issues)).

------------
## Useful links

* [Issue Tracker](https://github.com/shomykohai/quest-system/issues)
* [QuestSystem on the Godot Asset Library](https://godotengine.org/asset-library/asset/2516)