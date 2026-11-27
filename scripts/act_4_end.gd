extends Node2D

func _ready() -> void:
	print("loading act 4 end")
	DialogueManager.initiate_dialogue("res://dialogues/act_4_end.json")
