class_name CollectibleItem
extends TextureButton

@export var item_id: String = "placeholder"
@export var usable: bool = false

var collected: bool = false


func _ready() -> void:
	var bitmap := BitMap.new()
	bitmap.create_from_image_alpha(texture_normal.get_image())
	texture_click_mask = bitmap


func _on_pressed() -> void:

	if collected:
		return

	collected = true

	# Register the item in GameManager
	GameManager.add_item(item_id)

	# Add the object to the inventory UI
	InventoryUi.add_item(self, item_id)

	# Hide its original appearance
	self_modulate.a = 0.0
