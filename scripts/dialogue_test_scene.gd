extends Node2D

var dialogue_ongoing: bool = false

func _ready() -> void:
	DialogueManager.dialogue_end.connect(_on_dialogue_end)

func _on_button_pressed() -> void:
	print("Dialogue initiated")
	$CanvasLayer/Button.disabled = true
	DialogueManager.initiate_dialogue("res://dialogues/test_dialogue_text.json")
	dialogue_ongoing = true

func _on_dialogue_end() -> void:
	dialogue_ongoing = false
	$CanvasLayer/Button.disabled = false

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("continue_dialogue") and dialogue_ongoing:
		DialogueManager.display_current_line()
	
