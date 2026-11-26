extends Node2D

func _ready() -> void:
	DialogueManager.dialogue_end.connect(_on_dialogue_end)

func _on_button_pressed() -> void:
	print("Dialogue initiated")
	$CanvasLayer/Button.disabled = true
	DialogueManager.initiate_dialogue("res://dialogues/act_1_part_2.json")

func _on_dialogue_end() -> void:
	$CanvasLayer/Button.disabled = false
	
