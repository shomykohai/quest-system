extends BaseQuestPool
class_name ActiveQuestPool

func update_objective(quest_id: int) -> void:
	var quest: Quest = get_quest_from_id(quest_id)

	quest.update()
