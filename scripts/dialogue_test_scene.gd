extends Node2D

func _ready() -> void:
	DialogueManager.dialogue_end.connect(_on_dialogue_end)

func _on_button_pressed() -> void:
	print("Dialogue initiated")
	$CanvasLayer/Button.disabled = true
	DialogueManager.initiate_dialogue("res://dialogues/experimental_dialogue_text.json")

func _on_dialogue_end() -> void:
	$CanvasLayer/Button.disabled = false

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("continue_dialogue") and DialogueManager.dialogue_ongoing:
		DialogueManager.display_current_line()
	
