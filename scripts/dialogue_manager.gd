extends Node

var dialogue_lines: Array
var current_line_idx: int

@onready var character_name: Label = get_node("/root/DialogueUI/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/CharacterNameLabel")
@onready var character_message: Label = get_node("/root/DialogueUI/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/CharacterMessageLabel")

func load_dialogue_json(dialogue_path: String) -> Dictionary:
	# Basically import the entire json file as text
	var dialogue_file = FileAccess.open(
		dialogue_path,
		FileAccess.READ
	)
	var extract_text = dialogue_file.get_as_text()
	dialogue_file.close()
	
	# Convert the text into an actual dictionary
	var json = JSON.new()
	var error = json.parse(extract_text)
	var data = json.data
	
	return data

func initiate_dialogue(dialogue_path: String) -> void:
	# Get the array of all the dialogues from a json file
	var dialogue_json: Dictionary = load_dialogue_json(dialogue_path)
	var dialogue_data = dialogue_json["dialogue"]
	
	# Set initial conditions
	dialogue_lines = dialogue_data
	current_line_idx = 0

func display_current_line() -> void:
	var current_line: Dictionary = dialogue_lines[current_line_idx]
	character_name.text = current_line["speaker"]
	character_message.text = current_line["text"]
	
	current_line_idx += 1

#func _ready():
	#initiate_dialogue("res://dialogues/test_dialogue_text.json")
	
