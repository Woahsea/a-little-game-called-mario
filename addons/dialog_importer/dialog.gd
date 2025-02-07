extends Resource

"""
A single message of a dialog.

Can have multiple responses the player can choose.
Can trigger events, give items and change the character sprite.
It is possible to create branching dialogs with conditions.
"""

export var text: Array
export var choices: Array

export var item: String
export var event: String
export var new_sprite: Texture

export var condition: Resource
# If the condition applies to this dialog or if there are two possible branches
# for each outcome.
export var has_branches := false

# The dialog to execute if the condition is true.
export var True: Resource
# The dialog to execute if the condition is false.
export var False: Resource

const Condition = preload("res://addons/dialog_importer/condition.gd")
const Choice = preload("res://addons/dialog_importer/choice.gd")

func _init(data = {}) -> void:
	if data is String:
		text = [data]
		return
	if "condition" in data:
		condition = Condition.new(data.condition)
	if "false" in data:
		has_branches = true
		True = get_script().new(data.get("true"))
		False = get_script().new(data.get("false"))
		return
	if "set_sprite" in data:
		new_sprite = load("res://sprites/%s.png" % data.set_sprite)
	var text_data = data.get("text", "")
	if text_data is String:
		text = [text_data]
	else:
		text = text_data
	var choice_data = data.get("choices", [])
	for data in choice_data:
		choices.append(Choice.new(data))
	item = data.get("item", "")
	event = data.get("event", "")
