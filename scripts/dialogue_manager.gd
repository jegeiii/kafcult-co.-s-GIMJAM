extends Node

var current_dialogue_events: Array				# Contain all of the events of the current dialogue
var current_event_idx: int				# The index of the current dialogue line
var dialogue_ongoing: bool				# Is there a dialogue ongoing?
# If there's as flashback, save the state of the dialogue
# Come back to it once the flashback is finished
var previous_dialogue_events: Array
var previous_event_idx: int
var flashback_ongoing: bool
var current_flashback_id: int
var flashback_transition: bool

signal dialogue_start
signal dialogue_end
signal load_text(speaker, message_fragments)
signal load_sprite(name, position, expression)
signal unload_sprite(name)
signal change_background(path, receiver)
signal highlight_speaker(speaker)
signal flashback_start(id)
signal flashback_end(id)

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
	current_dialogue_events = events
	current_event_idx = 0
	
	# Display the first event
	dialogue_next()

func display_current_event() -> void:
	var event: Dictionary = current_dialogue_events[current_event_idx]
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
		"Flashback":
			current_event_idx += 1
			var flashback_id = event["flashback_id"]
			current_flashback_id = flashback_id
			initiate_flashback(flashback_id)
		"PlaySoundEffect":
			var SFX_path = event["path"]
			AudioManager.play_sfx(SFX_path)
		"Special":
			print("Special Effect")
		"ChangeBackground":
			var BG_path = event["path"]
			var receiver = event["receiver"]
			change_background.emit(BG_path, receiver)

# Runs every next LoadSprite event and 1 LoadText, essentially "grouping" them ig
# Code runs under the assumption that the last event in the dialogue is a LoadText event
func dialogue_next() -> void:
	if current_event_idx == current_dialogue_events.size():
		finish_dialogue()
		return

	var curr_event = current_dialogue_events[current_event_idx]
	var curr_event_name = curr_event["name"]
	
	while curr_event_name != "LoadText" and curr_event_name != "Flashback":
		display_current_event()

		current_event_idx += 1
		
		if current_event_idx >= current_dialogue_events.size():
			finish_dialogue()
			return
		
		curr_event = current_dialogue_events[current_event_idx]
		curr_event_name = curr_event["name"]

	if curr_event_name == "Flashback":
		display_current_event()
	else:
		display_current_event()
		current_event_idx += 1

var FLASHBACK_FILES: Dictionary = {
	1: "res://dialogues/flashback_1.json",
	2: "res://dialogues/flashback_2.json",
	3: "res://dialogues/flashback_3.json",
	4: "res://dialogues/flashback_4.json",
	5: "res://dialogues/flashback_5.json",
	6: "res://dialogues/flashback_6.json",
	7: "res://dialogues/flashback_7.json"
}

var FLASHBACK_SCENES: Dictionary = {
	6: "res://scenes/flashback_vi.tscn",
	7: "res://scenes/flashback_vii.tscn"
}

func initiate_flashback(flashback_id: int) -> void:
	flashback_start.emit(current_flashback_id)
	print("FLASHBACK STARTS")
	flashback_ongoing = true
	# Save the state before doing the flashback
	previous_dialogue_events = current_dialogue_events
	previous_event_idx = current_event_idx
	
	# Load the flashback
	var flashback_path = FLASHBACK_FILES[flashback_id]
	var flashback_json: Dictionary = load_dialogue_json(flashback_path)
	current_dialogue_events = flashback_json["events"]
	current_event_idx = 0
	
	# Prolly have a signal to change the scene
	dialogue_next()

func finish_dialogue() -> void:
	print("finish_dialogue()")
	if flashback_ongoing:
		# Return to previous state
		current_dialogue_events = previous_dialogue_events
		current_event_idx = previous_event_idx
		flashback_ongoing = false
		
		# Some signal to go back to the main scene
		flashback_end.emit(current_flashback_id)
		dialogue_next()
		print("FLASHBACK ENDS")
	else:
		dialogue_end.emit()
		dialogue_ongoing = false
		print("DIALOGUE ENDS")

func _ready():
	# initiate_dialogue("res://dialogues/experimental_dialogue_text.json")
	pass
	
