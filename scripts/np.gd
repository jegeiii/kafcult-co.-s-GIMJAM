extends Control

var count: int = 0
var hands_count: int = 0
signal dismembered()

var call = 0

func check_member():
	DialogueManager.dialogue_end.disconnect(check_member)
	if count >= 5:
		print("ENDED ON CALL {call}".format({"call": call}))
		DialogueManager.dialogue_ongoing = false
		print(DialogueManager.dialogue_ongoing)
		dismembered.emit()
		InventoryUi.close_inspect()
		visible = false

func check_hands():
	if hands_count == 2:
		count += 2
		call += 1
		print("call: {call}".format({"call": call}))
		DialogueManager.dialogue_end.connect(check_member)
		DialogueManager.initiate_dialogue("res://dialogues/rip_hands.json")

func _on_heart_pressed() -> void:
	if InventoryUi.using_item == "knife":
		call += 1
		print("call: {call}".format({"call": call}))
		DialogueManager.dialogue_end.connect(check_member)
		DialogueManager.initiate_dialogue("res://dialogues/rip_heart.json")
		count += 1
		$heart.visible = false

func _on_eyes_pressed() -> void:
	if InventoryUi.using_item == "knife":
		call += 1
		print("call: {call}".format({"call": call}))
		DialogueManager.dialogue_end.connect(check_member)
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
		call += 1
		print("call: {call}".format({"call": call}))
		DialogueManager.dialogue_end.connect(check_member)
		DialogueManager.initiate_dialogue("res://dialogues/rip_head.json")
		count += 1
		$head.visible = false
