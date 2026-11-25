extends Node

var dialogue_lines: Array			# Array of dialogue lines
var current_line_idx: int			# The index of the current dialogue line
var dialogue_ongoing: bool
var dialogue_line_ongoing: bool

signal dialogue_start
signal dialogue_end
signal load_next_line(speaker, message)
signal load_sprite(name, position, expression)

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
	dialogue_ongoing = true
	
	# Get the array of all the dialogues from a json file
	var dialogue_json: Dictionary = load_dialogue_json(dialogue_path)
	var dialogue_lines_data = dialogue_json["dialogue"]
	
	# Emit the signal that loads the dialogue box
	dialogue_start.emit()
	
	# Setup all the characters (get position to use later)
	dialogue_lines = dialogue_lines_data
	var characters = dialogue_json["characters"]
	for character in characters:
		if character["name"] != "Narrator":
			load_sprite.emit(character["name"], character["int_pos"], character["int_exp"])
	
	current_line_idx = 0
	
	# Display the first line
	display_current_line()

func display_current_line() -> void:
	var current_line: Dictionary = dialogue_lines[current_line_idx]
	var current_speaker = current_line["speaker"]
	var current_expression = current_line["expression"]
	var current_delivery = current_line["delivery"]
	var current_message = current_line["segments"]
	
	# Emit signal to load the next line
	load_next_line.emit(current_speaker, current_message)
	
	# Emit signal to load the next sprite
	if current_delivery != "narration":
		var current_position = current_line["position"]
		load_sprite.emit(current_speaker, current_position, current_expression)
	
	current_line_idx += 1
	
	# If reached the end of the array, emit signal to end the dialogue
	if current_line_idx == dialogue_lines.size():
		dialogue_end.emit()
		dialogue_ongoing = false

func _ready():
	# initiate_dialogue("res://dialogues/experimental_dialogue_text.json")
	pass
	
