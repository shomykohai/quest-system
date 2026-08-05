extends EditorTranslationParserPlugin

func _parse_file(path: String) -> Array[PackedStringArray]:
	var res := ResourceLoader.load(path)
	if not res: return []
	if not res is Quest: return []

	var ret: Array[PackedStringArray] = []
	for property in res.get_script().get_script_property_list():
		var msgids: PackedStringArray = []
		if property.type != 4: continue # If the property is not a string, we skip it

		# Here we check if the property is an exported variable
		if property.usage == PROPERTY_USAGE_SCRIPT_VARIABLE | PROPERTY_USAGE_STORAGE | PROPERTY_USAGE_EDITOR:
			# [msgid, msgctxt, msgid_plural, comment, source_line]
			msgids.append("quest_%s/%s"% [res.id, property.name]) # msgid
			msgids.append("Quest ID: %s, property: %s"% [res.id, property.name]) # msgctxt
			msgids.append("") # msgid_plural
			msgids.append("") # comment

			ret.append(msgids)

	return ret

func _get_recognized_extensions() -> PackedStringArray:
	return ['tres']
