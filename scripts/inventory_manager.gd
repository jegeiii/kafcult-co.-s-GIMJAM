extends Control

#var inventory_slot: Dictionary
var inventory_ui: Dictionary
var scene_lock = true
@export var using_item: String = "none"
#var inspect_depth: int = 0;
signal fade_black_pressed
signal written_paper_clicked

func _process(delta):
	if Input.is_action_pressed("RMB"):
		$tip.visible = false
		using_item = "none"
		$TextureRect.global_position = Vector2(-100, -100)
	if using_item != "none":
		$TextureRect.texture = load(inventory_ui[using_item]["texture_path"])
		$TextureRect.global_position = get_global_mouse_position() + Vector2(16, -16)

func toggle_inventory(state: bool):
	self.visible = state

func expand_inventory():
	if $Button/Label.text == "<":
		$Button/Label.text = ">"
		#$Button.set_position($button_opened.position)
		$CanvasLayer/PanelContainer.set_position($inventory_opened.position)
	elif $Button/Label.text == ">":	
		$Button/Label.text = "<"
		#$Button.set_position($button_closed.position)
		$CanvasLayer/PanelContainer.set_position($inventory_closed.position)

func load_inventory(json_path: String) -> void:
	var file = FileAccess.open(json_path, FileAccess.READ)
	var text_extract = file.get_as_text()
	file.close()
	
	var json = JSON.new()
	var error = json.parse(text_extract)
	var data = json.data
	
	inventory_ui = data


func add_item(item: TextureButton, item_id: String) -> void:
	# Check whether this item is already in the inventory
	var already_owned := GameManager.has_item(item_id)

	# Update the actual inventory data
	GameManager.add_item(item_id)
	inventory_ui[item_id]["count"] += 1

	if already_owned:
		item.queue_free()
	else:
		# This is the first time collecting this item.
		# Move its button into the inventory UI.
		item.name = item_id
		item.custom_minimum_size = Vector2(50, 50)
		await get_tree().create_timer(0.2).timeout
		item.reparent(
			get_node("/root/InventoryUi/CanvasLayer/PanelContainer/ScrollContainer/VBoxContainer")
		)

		# Make it behave like an inventory item
		item.button_interaction = "inventory"

	notification_popup(item_id)
	update_item_quantity(item_id)
	
	print("Inventory: ", GameManager.inventory)

func remove_item(item_id: String, amount: int = 1) -> void:

	GameManager.remove_item(item_id, amount)
	inventory_ui[item_id]["count"] -= 1

	# If the player no longer owns this item, remove its icon from the inventory UI.
	if not GameManager.has_item(item_id):
		var inventory_container = get_node(
	        "/root/InventoryUi/CanvasLayer/PanelContainer/ScrollContainer/VBoxContainer"
		)

		var item_icon = inventory_container.get_node_or_null(item_id)

		if item_icon:
			item_icon.queue_free()

func use_item(item_id: String):
	using_item = item_id
	$tip.visible = true
	#remove_item(item_id)
	close_inspect()

func notification_popup(item_id: String):
	$notification/RichTextLabel.visible = true
	for i in range(5):
		$notification/RichTextLabel.text = "Obtained "
		$notification/RichTextLabel.text += inventory_ui[item_id]["name"]
		$notification/Timer.start(0.2)
		await $notification/Timer.timeout
		$notification/RichTextLabel.visible = not $notification/RichTextLabel.visible
	$notification/RichTextLabel.visible = false
		
func InventoryInspect(item_id: String, usable: bool):
	print("a")
	$fade_black/a.transparent()
	$fade_black/a.mouse_filter = Control.MOUSE_FILTER_STOP
	$item_inspect/item_closeup/PanelContainer/RichTextLabel.text = inventory_ui[item_id]["description"]
	$item_inspect/item_closeup/PanelContainer2/RichTextLabel.text = inventory_ui[item_id]["name"]
	$item_inspect/item_closeup.visible = true
	$item_inspect/item_closeup/use_button.visible = usable
	$item_inspect/item_closeup.texture_normal = load(inventory_ui[item_id]["texture_path"])
	$item_inspect/item_closeup/Label.text = item_id
	update_item_closeup_clickmask()

func update_item_closeup_clickmask():
	var bitmap := BitMap.new()
	bitmap.create_from_image_alpha($item_inspect/item_closeup.texture_normal.get_image())
	$item_inspect/item_closeup.texture_click_mask = bitmap

func update_item_quantity(item_id: String) -> void:

	var container = get_node(
	    "/root/InventoryUi/CanvasLayer/PanelContainer/ScrollContainer/VBoxContainer"
	)

	var item_icon = container.get_node_or_null(item_id)

	if item_icon == null:
		return

	var quantity = GameManager.get_item_count(item_id)

	var label = item_icon.get_node("QuantityLabel")

	label.text = "×" + str(quantity)
	label.visible = quantity > 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#DialogueManager.dialogue_end.connect(_on_dialogue_end)
	load_inventory("res://item.json")
	#print(inventory)
	print(inventory_ui["a"]["name"])
	print(inventory_ui["b"]["description"])
	
#func save():
	#var file = FileAccess.open("res://items.json", FileAccess.WRITE)
	#file.store_string(JSON.stringify(inventory_ui, "\t"))
	#file.close

func _on_fade_black_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("LMB"):
		close_inspect()

func _on_use_button_pressed() -> void:
	use_item($item_inspect/item_closeup/Label.text)

func close_inspect():
	fade_black_pressed.emit()
	$item_inspect/item_closeup.visible = false
	$fade_black/a.fade_in(0.1)
	$fade_black/a.mouse_filter = MOUSE_FILTER_IGNORE

func _on_item_closeup_pressed() -> void:
	if $item_inspect/item_closeup/Label.text == "letter_to_william":
		$item_inspect/item_closeup.texture_normal = load("res://graphics/letter_to_william_opened.png")
		update_item_closeup_clickmask()
		await get_tree().create_timer(0.5).timeout
		AudioManager.play_sfx("res://audio/act1_2.wav")
		$item_inspect/item_closeup.texture_normal = load("res://graphics/letter_to_william_paper.png")
		update_item_closeup_clickmask()
		$item_inspect/item_closeup/Label.text = "letter_to_william_paper"
	elif $item_inspect/item_closeup/Label.text == "letter_to_william_paper":
		written_paper_clicked.emit()
		close_inspect()
		#DialogueManager.initiate_dialogue("res://dialogues/act_1_part_2.json")
		#scene_lock = false

#func _on_dialogue_end():
	#if !scene_lock:
		#GameManager.change_act_to(2)

func fade_in(duration: float):
	$fade_black/a.fade_in(duration)
	
func fade_out(duration: float):
	$fade_black/a.fade_out(duration)
