## How do I add translations to my project?

QuestSystem can be integrated with [Godot translations system](https://docs.godotengine.org/en/stable/tutorials/i18n/index.html) with ease.<br>
Supported translation format are PO and CSV.

## Generating POT files for PO translation

Head to `Project` -> `Project Settings` -> `Localization` and click on the `Add` button.<br>
Here you want to select all the quest files you want to translate.
![Localisation Settings](assets\translations\localisation_settings.png)

A new `.pot` file will be generated containing all the string needed.<br>
QuestSystem, instead of storing the actual string in the pot `msgid`, stores a simplified id to access the translation.<br>
Quest strings `msgids` are stored in the current format: `quest_<quest-id>/<quest_property>`, so make sure you have no conflicting IDs in your quest resources.<br>

## How to use translations in my UI?

To use the translations, simply call godot's `tr` method and pass the id of the key you want to use.


Let's assume we have a quest resource populated with the following data:<br>

| key               | value                                                                                             |
|-------------------|---------------------------------------------------------------------------------------------------|
| id                | 1                                                                                                 |
| quest_name        | The Old man lost hammer                                                                           |
| quest_description | The old man lost his hammer and he cannot find it anywhere. He's looking for someone to help him. |
| quest_objective   | Help the old man find his hammer.                                                                 |


After filling the quest data, we will generate the POT file and make the translations.<br>

| msgid                       | en                                                                                                | it                                                                                                  |   |   |
|---------------------------|---------------------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------|---|---|
| quest_1/quest_name        | The Old Man lost hammer                                                                           | Il martello perduto dell'anziano.                                                                   |   |   |
| quest_1/quest_description | The old man lost his hammer and he cannot find it anywhere. He's looking for someone to help him. | L'anziano ha perso il suo martello e non riesce più a trovarlo. Sta cercando qualcuno che lo aiuti. |   |   |
| quest_1/quest_objective   | Help the old man find his hammer.                                                                 | Aiuta l'anziano a trovare il suo martello.                                                          |   |   |

<br>
Finally, we want to show the quest name in the label of the UI:

```gdscript
# ui.gd

extends Node

@onready var label: Label = $Label

func _ready()
    # locale: en
    label.text = tr("quest_1/quest_name") # The Old man lost hammer
    TranslationServer.set_locale("it") # set locale to: it
    label.text = tr("quest_1/quest_name") # Il martello perduto dell'anziano.

```


