extends Node2D

@export var audio: Array[AudioStream] = []
var transition_to: String
var starting_dialogue_path: String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#DialogueManager.dialogue_end.connect(_on_dialogue_end)
	DialogueManager.change_background.connect(change_background)
	get_node("/root/InventoryUi/item_inspect/item_closeup/pw").correct.connect(_on_pw_correct)
	get_node("/root/InventoryUi/item_inspect/item_closeup/pw").incorrect.connect(_on_pw_incorrect)
	get_node("/root/InventoryUi/item_inspect/item_closeup/np").dismembered.connect(_on_dismembered)
	await get_tree().create_timer(1).timeout
	#DialogueManager.initiate_dialogue("res://dialogues/act_2_part_1.json")
	#DialogueManager.initiate_dialogue("res://dialogues/flashback_2.json")

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
	#DialogueManager.dialogue_end.connect(dining_room_done)
	$dining_room/door.visible = true

func dining_room_done():
	#DialogueManager.dialogue_end.disconnect(dining_room_done)
	InventoryUi.fade_out(0.2)
	await get_tree().create_timer(0.2).timeout
	$dining_room.visible = false
	$distorted_dining_room.visible = true
	InventoryUi.fade_in(0.2)
	await get_tree().create_timer(0.2).timeout
	DialogueManager.initiate_dialogue("res://dialogues/act_2_part_4.json")


func _on_charless_sillhouette_pressed() -> void:
	if InventoryUi.inventory_ui["rotten_vegetable"]["count"] >= 1 and InventoryUi.inventory_ui["rotten_meat"]["count"] >= 1 and InventoryUi.inventory_ui["plate"]["count"] >= 1:
		InventoryUi.remove_item("rotten_vegetable", 1)
		InventoryUi.remove_item("rotten_meat", 1)
		InventoryUi.remove_item("plate", 1)
		DialogueManager.initiate_dialogue("res://dialogues/act_2_part_6.json")
		DialogueManager.dialogue_end.connect(flashback_1)

func flashback_1():
	DialogueManager.dialogue_end.disconnect(flashback_1)
	print("flashback 1")
	InventoryUi.fade_out(1)
	InventoryUi.flashback_notification()
	await get_tree().create_timer(1).timeout
	$distorted_dining_room.visible = false
	$flashback_1.visible = true
	InventoryUi.fade_in(1)
	await get_tree().create_timer(1).timeout
	DialogueManager.initiate_dialogue("res://dialogues/flashback_1.json")
	DialogueManager.dialogue_end.connect(flashback_1_end)

func flashback_1_end():
	DialogueManager.dialogue_end.disconnect(flashback_1_end)
	InventoryUi.fade_out(1)
	InventoryUi.flashback_notification("FLASHBACK FINISHED")
	await get_tree().create_timer(1).timeout
	$distorted_dining_room.visible = true
	$flashback_1.visible = false
	InventoryUi.fade_in(1)
	await get_tree().create_timer(1).timeout
	DialogueManager.initiate_dialogue("res://dialogues/act_2_part_6_afterFB.json")
	InventoryUi.add_item($distorted_dining_room/the_verse, $distorted_dining_room/the_verse.item_id)
	$distorted_dining_room/door.visible = true

func distorted_dining_room_done():
	InventoryUi.fade_out(1)
	await get_tree().create_timer(1).timeout
	$distorted_dining_room.visible = false
	$transition.visible = true
	InventoryUi.fade_in(1)
	await get_tree().create_timer(1).timeout
	starting_dialogue_path = "res://dialogues/act_2_part_7.json"
	transition_to = "basement"

func transition():
	InventoryUi.fade_out(1)
	await get_tree().create_timer(1).timeout
	get_node(transition_to).visible = true
	$transition.visible = false
	InventoryUi.fade_in(1)
	await get_tree().create_timer(1).timeout
	DialogueManager.initiate_dialogue(starting_dialogue_path)

var rotten_done: bool = false
func _on_rotten_vegetable_mouse_entered() -> void:
	if !rotten_done and InventoryUi.using_item == "knife":
		rotten_done = true
		DialogueManager.initiate_dialogue("res://dialogues/act_2_part_5.json")

func _on_rotten_meat_mouse_entered() -> void:
	if !rotten_done and InventoryUi.using_item == "knife":
		rotten_done = true
		DialogueManager.initiate_dialogue("res://dialogues/act_2_part_5.json")

func _on_plate_pressed() -> void:
	AudioManager.play_sfx("res://audio/Plate Interact.wav")

func _on_knife_pressed() -> void:
	AudioManager.play_sfx("res://audio/Knife Interact.wav")

func _on_rotten_vegetable_pressed() -> void:
	if InventoryUi.using_item == "knife":
		AudioManager.play_sfx("res://audio/Vegetable Cut Sound.wav")

func _on_rotten_meat_pressed() -> void:
	if InventoryUi.using_item == "knife":
		AudioManager.play_sfx("res://audio/Meat Cut Sound.wav")

var given_water: bool = false
var given_food: bool = false
func _on_give_dog_food_and_water() -> void:
	$basement/dog.release_focus()
	if InventoryUi.using_item == "water":
		given_water = true
		InventoryUi.using_item = "none"
		InventoryUi.remove_item("water")
	if InventoryUi.using_item == "dogfood":
		given_food = true
		InventoryUi.using_item = "none"
		InventoryUi.remove_item("dogfood")
	if given_food and given_water:
		DialogueManager.initiate_dialogue("res://dialogues/act_2_part_8.json")
		$basement/dog.pressed.disconnect(_on_give_dog_food_and_water)
		$basement/dog.pressed.connect(_on_give_dog_toy)
	
func _on_give_dog_toy():
	$basement/dog.release_focus()
	if InventoryUi.using_item == "toy":
		InventoryUi.remove_item("toy")
		InventoryUi.using_item = "none"
		DialogueManager.initiate_dialogue("res://dialogues/act_2_part_9.json")
		$basement/dog.pressed.disconnect(_on_give_dog_toy)
		$basement/dog.pressed.connect(pet_dog)

func pet_dog():
	if InventoryUi.using_item == "none":
		$basement/dog.pressed.disconnect(pet_dog)
		flashback_2()

func change_background(path, receiver):
	var target = get_node(receiver)
	var tween = create_tween()
	tween.tween_property(target, "self_modulate", Color.BLACK, 0.5)
	await get_tree().create_timer(0.75).timeout
	target.texture = load(path)
	var tween1 = create_tween()
	tween1.tween_property(target, "self_modulate", Color.WHITE, 0.5)

func flashback_2():
	DialogueManager.dialogue_end.connect(flashback_2_end)
	InventoryUi.fade_out(1)
	InventoryUi.flashback_notification()
	await get_tree().create_timer(1).timeout
	$basement.visible = false
	$flashback_2.visible = true
	InventoryUi.fade_in(1)
	await get_tree().create_timer(1).timeout
	DialogueManager.initiate_dialogue("res://dialogues/flashback_2.json")
	DialogueManager.dialogue_end.connect(flashback_2_end)

func flashback_2_end():
	DialogueManager.dialogue_end.disconnect(flashback_2_end)
	InventoryUi.fade_out(1)
	InventoryUi.flashback_notification("FLASHBACK FINISHED")
	await get_tree().create_timer(1).timeout
	$flashback_2.visible = false
	$basement.visible = true
	InventoryUi.fade_in(1)
	await get_tree().create_timer(1).timeout
	var tween = create_tween()
	tween.tween_property($basement/dog, "self_modulate:a", 0.0, 2.0)
	DialogueManager.initiate_dialogue("res://dialogues/act_2_part_10.json")
	InventoryUi.add_item($basement/water_vial, $basement/water_vial.item_id)
	$basement/door.visible = true

func basement_done():
	InventoryUi.fade_out(1)
	await get_tree().create_timer(1).timeout
	$basement.visible = false
	$transition.visible = true
	InventoryUi.fade_in(1)
	await get_tree().create_timer(1).timeout
	starting_dialogue_path = "res://dialogues/act_2_part_11.json"
	transition_to = "parent's_bedroom"
	DialogueManager.dialogue_end.connect(flashback_3)

func flashback_3():
	DialogueManager.dialogue_end.disconnect(flashback_3)
	InventoryUi.fade_out(1)
	InventoryUi.flashback_notification()
	await get_tree().create_timer(1).timeout
	$"parent's_bedroom".visible = false
	$flashback_3.visible = true
	InventoryUi.fade_in(1)
	await get_tree().create_timer(1).timeout
	DialogueManager.initiate_dialogue("res://dialogues/flashback_3.json")
	DialogueManager.dialogue_end.connect(flashback_3_end)

func flashback_3_end():
	DialogueManager.dialogue_end.disconnect(flashback_3_end)
	InventoryUi.fade_out(1)
	InventoryUi.flashback_notification("FLASHBACK FINISHED")
	await get_tree().create_timer(1).timeout
	$"parent's_bedroom".visible = true
	$flashback_3.visible = false
	InventoryUi.fade_in(1)
	await get_tree().create_timer(1).timeout
	DialogueManager.initiate_dialogue("res://dialogues/act_2_part_11_afterFB.json")
	DialogueManager.dialogue_end.connect(parents_bedroom)

func parents_bedroom():
	DialogueManager.dialogue_end.disconnect(parents_bedroom)
	InventoryUi.add_item($"parent's_bedroom/jewelry_box", $"parent's_bedroom/jewelry_box".item_id)
	InventoryUi.add_item($"parent's_bedroom/poem", $"parent's_bedroom/poem".item_id)
	
func _on_pw_correct():
	print("correctt")
	DialogueManager.initiate_dialogue("res://dialogues/act_2_part_12.json")
	InventoryUi.add_item($"parent's_bedroom/necklace", $"parent's_bedroom/necklace".item_id)
	$"parent's_bedroom/door".visible = true

func _on_pw_incorrect():
	print("incorrectt")
	DialogueManager.initiate_dialogue("res://dialogues/act_2_part_13.json")

func parents_bedroom_done() -> void:
	InventoryUi.fade_out(1)
	await get_tree().create_timer(1).timeout
	$"parent's_bedroom".visible = false
	$transition.visible = true
	InventoryUi.fade_in(1)
	await get_tree().create_timer(1).timeout
	starting_dialogue_path = "res://dialogues/act_2_part_14.json"
	transition_to = "distorted_kids_room"
	DialogueManager.dialogue_end.connect(flashback_4)

func flashback_4():
	DialogueManager.dialogue_end.disconnect(flashback_4)
	InventoryUi.fade_out(1)
	InventoryUi.flashback_notification()
	await get_tree().create_timer(1).timeout
	$distorted_kids_room.visible = false
	$flashback_4.visible = true
	InventoryUi.fade_in(1)
	await get_tree().create_timer(1).timeout
	DialogueManager.initiate_dialogue("res://dialogues/flashback_4.json")
	DialogueManager.dialogue_end.connect(flashback_4_end)

func flashback_4_end():
	DialogueManager.dialogue_end.disconnect(flashback_4_end)
	InventoryUi.fade_out(1)
	InventoryUi.flashback_notification("FLASHBACK FINISHED")
	await get_tree().create_timer(1).timeout
	$distorted_kids_room.visible = true
	$flashback_4.visible = false
	InventoryUi.fade_in(1)
	await get_tree().create_timer(1).timeout
	DialogueManager.initiate_dialogue("res://dialogues/act_2_part_14_afterFB.json")

func _on_dismembered():
	$distorted_kids_room/nathaniels_painting.texture_normal = load("res://graphics/nathaniels_painting_body.png")
	DialogueManager.initiate_dialogue("res://dialogues/act_2_part_15.json")
	DialogueManager.dialogue_end.connect(distorted_kids_room_done)

func distorted_kids_room_done():
	print("dismembered")
	DialogueManager.dialogue_end.disconnect(distorted_kids_room_done)
	InventoryUi.add_item($distorted_kids_room/blood, $distorted_kids_room/blood.item_id)
	transition_to = "office"
	starting_dialogue_path = "res://dialogues/act_2_part_16.json"
	$distorted_kids_room/door.visible = true
