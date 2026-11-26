extends Node

#var inventory_slot: Dictionary
var inventory: Dictionary
var using_item: String
signal fade_black_pressed

func toggle_inventory(state: bool):
	self.visible = state

func expand_inventory():
	if $Button.text == "<":
		$Button.text = ">"
		$Button.set_position($button_opened.position)
		$PanelContainer.set_position($inventory_opened.position)
	elif $Button.text == ">":
		$Button.text = "<"
		$Button.set_position($button_closed.position)
		$PanelContainer.set_position($inventory_closed.position)

func load_inventory(json_path: String) -> void:
	var file = FileAccess.open(json_path, FileAccess.READ)
	var text_extract = file.get_as_text()
	file.close()
	
	var json = JSON.new()
	var error = json.parse(text_extract)
	var data = json.data
	
	inventory = data

func add_item(item: TextureButton, item_id: String):
	item.custom_minimum_size = Vector2(50, 50)
	item.reparent(get_node("/root/InventoryUi/PanelContainer/ScrollContainer/VBoxContainer"))
	
	inventory[item_id]["count"] += 1
	notification_popup(item_id)
	print(inventory[item_id]["count"])
	#save()

func remove_item(item_id: String):
	inventory[item_id]["count"] -= 1
	if inventory[item_id]["count"] <= 0:
		$PanelContainer/ScrollContainer/VBoxContainer.remove_child(get_node("PanelContainer/ScrollContainer/VBoxContainer/" + item_id))
	#save()

func use_item(item_id: String):
	using_item = item_id
	#remove_item(item_id)
	close_inspect()

func notification_popup(item_id: String):
	$notification/RichTextLabel.visible = true
	for i in range(5):
		$notification/RichTextLabel.text = "Obtained "
		$notification/RichTextLabel.text += inventory[item_id]["name"]
		$notification/Timer.start(0.2)
		await $notification/Timer.timeout
		$notification/RichTextLabel.visible = not $notification/RichTextLabel.visible
	$notification/RichTextLabel.visible = false
		
func InventoryInspect(item_id: String, usable: bool):
	print("a")
	$fade_black.transparent()
	$fade_black.mouse_filter = Control.MOUSE_FILTER_STOP
	$item_closeup/PanelContainer/RichTextLabel.text = inventory[item_id]["description"]
	$item_closeup.visible = true
	$item_closeup/use_button.visible = usable
	$item_closeup.texture_normal = load(inventory[item_id]["texture_path"])
	$item_closeup/Label.text = item_id

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_inventory("res://item.json")
	#print(inventory)
	print(inventory["a"]["name"])
	print(inventory["b"]["description"])
	
func save():
	var file = FileAccess.open("res://items.json", FileAccess.WRITE)
	file.store_string(JSON.stringify(inventory, "\t"))
	file.close

func _on_fade_black_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("LMB"):
		close_inspect()

func _on_use_button_pressed() -> void:
	use_item($item_closeup/Label.text)

func close_inspect():
	fade_black_pressed.emit()
	$item_closeup.visible = false
	$fade_black.fade_in(0.1)
	$fade_black.mouse_filter = Control.MOUSE_FILTER_IGNORE

func _on_item_closeup_pressed() -> void:
	pass
	#if inventory[item_id]["inspect_depth"] > 0:
		
