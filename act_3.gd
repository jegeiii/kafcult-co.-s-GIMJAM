extends Node2D

func _ready() -> void:
	DialogueManager.initiate_dialogue("res://dialogues/act_3_part_1.json")
	DialogueManager.flashback_start.connect(_on_flashback_start)
	DialogueManager.flashback_end.connect(_on_flashback_end)

@onready var main_bg: TextureRect = %MainSceneBackground
@onready var flashback_bg: TextureRect = %FlashbackBackground

func _on_flashback_start() -> void:
	DialogueManager.flashback_transition = true
	InventoryUi.fade_out(1)
	await get_tree().create_timer(1).timeout
	main_bg.visible = false
	flashback_bg.visible = true
	InventoryUi.fade_in(1)
	await get_tree().create_timer(1).timeout
	DialogueManager.flashback_transition = false

func _on_flashback_end() -> void:
	DialogueManager.flashback_transition = true
	InventoryUi.fade_out(1)
	await get_tree().create_timer(1).timeout
	flashback_bg.visible = false
	main_bg.visible = true
	InventoryUi.fade_in(1)
	await get_tree().create_timer(1).timeout
	DialogueManager.flashback_transition = false
