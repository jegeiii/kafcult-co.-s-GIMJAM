extends Control

var count: int = 0
var hands_count: int = 0
signal dismembered()

func _ready():
	DialogueManager.dialogue_end.connect(check_member)

func check_member():
	if count >= 5:
		DialogueManager.dialogue_end.disconnect(check_member)
		InventoryUi.close_inspect()
		#DialogueManager.initiate_dialogue("res://dialogues/act_2_part_15.json")
		InventoryUi.add_item(get_node("/root/ACT2/distorted_kids_room/blood"), get_node("/root/ACT2/distorted_kids_room/blood").item_id)
		get_node("/root/ACT2").transition_to = "office"
		get_node("/root/ACT2").starting_dialogue_path = "res://dialogues/act_2_part_16.json"
		get_node("/root/ACT2/distorted_kids_room/door").visible = true
		dismembered.emit()
		#next()
		visible = false
	
func next():
	DialogueManager.initiate_dialogue("res://dialogues/act_2_part_15.json")
	#DialogueManager.dialogue_end.connect(_on_dialogue_end)

#func _on_dialogue_end():
	#InventoryUi.add_item($distorted_kids_room/blood, $distorted_kids_room/blood.item_id)
	#get_node("/root/ACT2").transition_to = "office"
	#get_node("/root/ACT2").starting_dialogue_path = "res://dialogues/act_2_part_16.json"
	#$distorted_kids_room/door.visible = true

func check_hands():
	if hands_count == 2:
		count += 2
		
		DialogueManager.initiate_dialogue("res://dialogues/rip_hands.json")

func _on_heart_pressed() -> void:
	if InventoryUi.using_item == "knife":
		
		DialogueManager.initiate_dialogue("res://dialogues/rip_heart.json")
		count += 1
		$heart.visible = false

func _on_eyes_pressed() -> void:
	if InventoryUi.using_item == "knife":
		
		DialogueManager.initiate_dialogue("res://dialogues/rip_eyes.json")
		count += 1
		$eyes.visible = false

func _on_hand_l_pressed() -> void:
	if InventoryUi.using_item == "knife":
		hands_count += 1
		check_hands()
		$handL.visible = false

func _on_hand_r_pressed() -> void:
	if InventoryUi.using_item == "knife":
		hands_count += 1
		check_hands()
		$handR.visible = false

func _on_head_pressed() -> void:
	if InventoryUi.using_item == "knife":
		
		DialogueManager.initiate_dialogue("res://dialogues/rip_head.json")
		count += 1
		$head.visible = false
