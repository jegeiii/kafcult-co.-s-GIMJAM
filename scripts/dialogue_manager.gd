extends Node

var dialogue_events: Array				# Contain all of the events of the current dialogue
var current_event_idx: int				# The index of the current dialogue line
var dialogue_ongoing: bool				# Is there a dialogue ongoing?

signal dialogue_start
signal dialogue_end
signal load_text(speaker, message_fragments)
signal load_sprite(name, position, expression)
signal unload_sprite(name)
signal highlight_speaker(speaker)

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
	var events = dialogue_json["events"]
	
	# Emit the signal that loads the dialogue box (basically make the dialogue box visible)
	dialogue_start.emit()
	
	# Save data to global
	dialogue_events = events
	current_event_idx = 0
	
	# Display the first event
	dialogue_next()

func display_current_event() -> void:
	var event: Dictionary = dialogue_events[current_event_idx]
	var event_name: String = event["name"]
	
	match event_name:
		"LoadSprite":
			var character_name = event["speaker"]
			var character_position = event["position"]
			var character_expression = event["expression"]
			load_sprite.emit(character_name, character_position, character_expression)
		"LoadText":
			var character_name = event["speaker"]
			var message_fragments = event["segments"]
			load_text.emit(character_name, message_fragments)
			highlight_speaker.emit(character_name)
		"UnloadSprite":
			var character_name = event["speaker"]
			unload_sprite.emit(character_name)
			

# Runs every next LoadSprite event and 1 LoadText, essentially "grouping" them ig
# Code runs under the assumption that the last event in the dialogue is a LoadText event
func dialogue_next() -> void:
	if current_event_idx == dialogue_events.size():
		dialogue_end.emit()
		dialogue_ongoing = false
		return

	var curr_event = dialogue_events[current_event_idx]
	var curr_event_name = curr_event["name"]
	
	# Displays all the LoadSprite events
	while curr_event_name != "LoadText":
		display_current_event()
		
		current_event_idx += 1
		curr_event = dialogue_events[current_event_idx]
		curr_event_name = curr_event["name"]
	
	# Display the 1 LoadText event
	display_current_event()
	current_event_idx += 1

func _ready():
	# initiate_dialogue("res://dialogues/experimental_dialogue_text.json")
	pass
	
