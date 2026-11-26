extends Node2D

@export var audio: Array[AudioStream] = []
@export var room_locked: bool = true
var to_room: String
var from_room: String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	DialogueManager.dialogue_end.connect(_on_dialogue_end)
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
	room_locked = false
	to_room = "distorted_dining_room"
	from_room = "dining_room"
	await get_tree().create_timer(3).timeout

func _on_dialogue_end():
	if !room_locked:
		room_locked = true
		InventoryUi.fade_out(1)
		await get_tree().create_timer(1).timeout
		get_node(from_room).visible = false
		get_node(to_room).visible = true
		InventoryUi.fade_in(1)
		
		DialogueManager.initiate_dialogue("res://dialogues/act_2_part_4.json")
