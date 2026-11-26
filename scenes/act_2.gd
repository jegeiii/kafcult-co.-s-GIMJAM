extends Node2D

@export var audio: Array[AudioStream] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	InventoryUi.fade_in(1)
	await get_tree().create_timer(1).timeout
	DialogueManager.initiate_dialogue("res://dialogues/act_2_part_1.json")

func _on_door_pressed() -> void:
	AudioManager.play_sfx("res://audio/Door.wav")
	InventoryUi.fade_out(1)
	await get_tree().create_timer(1).timeout
	$mansion_entrance.visible = false
	$dining_room.visible = true
	InventoryUi.fade_in(1)
	await get_tree().create_timer(1).timeout
	DialogueManager.initiate_dialogue("res://dialogues/act_2_part_2.json")


func _on_laci_pressed() -> void:
	$dining_room/laci.disabled = true
	InventoryUi.add_item($dining_room/laci/charles_key, $dining_room/laci/charles_key.item_id)
	AudioManager.play_sfx("res://audio/Key touch.wav")
	DialogueManager.initiate_dialogue("res://dialogues/act_2_part_3.json")
