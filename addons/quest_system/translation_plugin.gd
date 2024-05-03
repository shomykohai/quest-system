extends EditorTranslationParserPlugin

func _parse_file(path: String, msgids: Array[String], msgids_context_plural: Array[Array]) -> void:
    var res := ResourceLoader.load(path)
    if not res: return
    if not res is Quest: return 
    for property in res.get_script().get_script_property_list():
        if property.type != 4: continue # If the property is not a string, we skip it 
        # Here we check if the property is an exported variable
        if property.usage & PROPERTY_USAGE_STORAGE or property.usage & PROPERTY_USAGE_SCRIPT_VARIABLE:
            msgids.append("quest_%s/%s"% [res.id, property["name"]]) # quest_1/quest_name

func _get_recognized_extensions() -> PackedStringArray:
    return ['tres']
