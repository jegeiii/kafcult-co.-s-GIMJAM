extends Node

var inventory_slot: Dictionary
var item_json: Dictionary

func load_item_json(json_path: String) -> void:
	var file = FileAccess.open(json_path, FileAccess.READ)
	var text_extract = file.get_as_text()
	file.close()
	
	var json = JSON.new()
	var error = json.parse(text_extract)
	var data = json.data
	
	item_json = data

func add_item(item: TextureButton):
	item.custom_minimum_size = Vector2(50, 50)
	item.reparent(get_node("/root/InventoryUi/PanelContainer/ScrollContainer/VBoxContainer"))
	item.set_script(load("res://scripts/clickables.gd"))
	item.button_interaction = "inspect"
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#load_item_json("res://item.json")
	print(item_json)
	print(inventory_slot)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
