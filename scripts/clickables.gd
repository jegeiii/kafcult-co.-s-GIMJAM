extends TextureButton

@export var item_id = "placeholder"
@export var button_interaction = "get" #get or interact
@export var usable: bool = false

func _ready():
	InventoryUi.fade_black_pressed.connect(_on_root_fade_black_gui_input)
	var bitmap := BitMap.new()
	bitmap.create_from_image_alpha(texture_normal.get_image())
	texture_click_mask = bitmap
	#reset_size()
	#texture_normal = load(InventoryUi.inventory[item_id]["texture_path"])
	#print(item_id)

func _on_pressed():
	print("pressed")
	#print("pressed: ", interaction)
	if button_interaction == "get":
		button_interaction = "inventory"
		self_modulate.a = 0.0
		disabled = false
		InventoryUi.add_item(self, item_id)
	elif button_interaction == "inspect":
		disabled = true
		InventoryUi.InventoryInspect(item_id, usable)
	elif button_interaction == "inventory":
		disabled = true
		InventoryUi.InventoryInspect(item_id, usable)

func _on_root_fade_black_gui_input():
	set_deferred("disabled", false)
