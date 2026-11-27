extends Node2D

@onready var main_layer: CanvasLayer = $Act3Main/CanvasLayer
@onready var flashback_6_layer: CanvasLayer = $FlashbackVI/CanvasLayer
@onready var hallway_layer: CanvasLayer = $Hallway/CanvasLayer
@onready var secret_room_layer: CanvasLayer = $SecretRoom/CanvasLayer
@onready var flashback_7_layer: CanvasLayer = $FlashbackVII/CanvasLayer

func hide_node(node, canvaslayer) -> void:
	node.visible = false
	canvaslayer.hide()

func show_node(node, canvaslayer) -> void:
	node.visible = true
	canvaslayer.show()

func _ready() -> void:
	DialogueManager.initiate_dialogue("res://dialogues/act_3_part_1.json")
	DialogueManager.flashback_start.connect(_on_flashback_start)
	DialogueManager.flashback_end.connect(_on_flashback_end)
	
	# Connect to child signals
	$Act3Main.keyhole_clicked.connect(_on_keyhole_clicked)
	$Hallway/Door.input_event.connect(_on_hallway_door_clicked)
	show_node($Act3Main, main_layer)

func _on_flashback_start(flashback_id) -> void:
	DialogueManager.flashback_transition = true
	InventoryUi.fade_out(1)
	await get_tree().create_timer(1).timeout
	
	
	if flashback_id == 6:
		# show flashback 6
		hide_node($Act3Main, main_layer)
		show_node($FlashbackVI, flashback_6_layer)
	elif flashback_id == 7:
		# show flashback 7
		hide_node($SecretRoom, secret_room_layer)
		show_node($FlashbackVII, flashback_7_layer)
	
	InventoryUi.fade_in(1)
	await get_tree().create_timer(1).timeout
	DialogueManager.flashback_transition = false

func _on_flashback_end(flashback_id) -> void:
	DialogueManager.flashback_transition = true
	InventoryUi.fade_out(1)
	await get_tree().create_timer(1).timeout
	
	if flashback_id == 6:
		# hide flashback 6
		hide_node($FlashbackVI, flashback_6_layer)
		show_node($Act3Main, main_layer)
	elif flashback_id == 7:
		# hide flashback 7
		hide_node($FlashbackVII, flashback_7_layer)
		show_node($SecretRoom, secret_room_layer)
	
	InventoryUi.fade_in(1)
	await get_tree().create_timer(1).timeout
	DialogueManager.flashback_transition = false

var secret_entrance_unlocked: bool = false

func _on_keyhole_clicked() -> void:
	if secret_entrance_unlocked:
		load_hallway()
	if InventoryUi.using_item == "charles_key":
		InventoryUi.empty_hand()
		print("Entrance Unlocked")
		InventoryUi.push_notification("??? Unlocked")
		secret_entrance_unlocked = true

var on_hallway: bool = false

func load_hallway():
	print("GOING TO HALLWAY")
	InventoryUi.fade_out(1)
	await get_tree().create_timer(1).timeout
	hide_node($Act3Main, main_layer)
	show_node($Hallway, hallway_layer)
	
	InventoryUi.fade_in(1)
	await get_tree().create_timer(1).timeout
	on_hallway = true

func _on_hallway_door_clicked(viewport, event, shape_idx):
	if event is InputEventMouseButton and on_hallway:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			InventoryUi.fade_out(1)
			await get_tree().create_timer(1).timeout
			hide_node($Hallway, hallway_layer)
			show_node($SecretRoom, secret_room_layer)
			
			InventoryUi.fade_in(1)
			await get_tree().create_timer(1).timeout
			initiate_secret_room_scene()

func initiate_secret_room_scene():
	DialogueManager.initiate_dialogue("res://dialogues/act_3_part_2.json")
	
