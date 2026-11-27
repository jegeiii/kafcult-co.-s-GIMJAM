extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	#DialogueManager.dialogue_end.connect(_on_dialogue_end)

func play_dialogue():
	DialogueManager.initiate_dialogue("res://dialogues/act_2_part_15.json")
	DialogueManager.dialogue_end.connect(_on_dialogue_end)

func _on_dialogue_end():
	InventoryUi.add_item($distorted_kids_room/blood, $distorted_kids_room/blood.item_id)
	get_tree().transition_to = "office"
	get_tree().starting_dialogue_path = "res://dialogues/act_2_part_16.json"
	$distorted_kids_room/door.visible = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
