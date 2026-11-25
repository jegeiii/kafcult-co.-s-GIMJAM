extends Node

#var inventory_slot: Dictionary
var inventory: Dictionary
signal fade_black_pressed

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

func notification_popup(item_id: String):
	$notification/RichTextLabel.visible = true
	for i in range(5):
		$notification/RichTextLabel.text = "Obtained "
		$notification/RichTextLabel.text += inventory[item_id]["name"]
		$notification/Timer.start(0.2)
		await $notification/Timer.timeout
		$notification/RichTextLabel.visible = not $notification/RichTextLabel.visible
	$notification/RichTextLabel.visible = false
		
func InventoryInspect(item_id: String):
	print("a")
	$fade_black.transparent()
	$fade_black.mouse_filter = Control.MOUSE_FILTER_STOP
	$item_closeup/PanelContainer/RichTextLabel.text = inventory[item_id]["description"]
	$item_closeup.visible = true
	$item_closeup.texture_normal = load(inventory[item_id]["texture_path"])

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_inventory("res://item.json")
	#print(inventory)
	print(inventory["a"]["name"])
	print(inventory["b"]["description"])

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_fade_black_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("LMB"):
		fade_black_pressed.emit()
		$item_closeup.visible = false
		$fade_black.fade_in(0.1)
		$fade_black.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
