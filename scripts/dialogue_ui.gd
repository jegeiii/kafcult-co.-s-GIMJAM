extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	DialogueManager.initiate_dialogue("res://dialogues/test_dialogue_text.json")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("continue_dialogue"):
		DialogueManager.display_current_line()
		
