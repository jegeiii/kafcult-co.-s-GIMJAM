extends TextureButton

var water_given: bool = false
var blood_given: bool = false
var necklace_given: bool = false
var book_given: bool = false
var ink_given: bool = false
var verse_given: bool = false
signal fireplace_done()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var bitmap := BitMap.new()
	bitmap.create_from_image_alpha(texture_normal.get_image())
	texture_click_mask = bitmap


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_pressed() -> void:
	release_focus()
	if InventoryUi.using_item == "water_vial":
		water_given = true
		InventoryUi.using_item = "none"
		InventoryUi.remove_item("water_vial")
		give_ink()
	elif InventoryUi.using_item == "blood":
		blood_given = true
		InventoryUi.using_item = "none"
		InventoryUi.remove_item("blood")
		give_ink()
	elif InventoryUi.using_item == "necklace":
		necklace_given = true
		InventoryUi.using_item = "none"
		InventoryUi.remove_item("necklace")
		give_new_book()
	elif InventoryUi.using_item == "ritual_book_before":
		book_given = true
		InventoryUi.using_item = "none"
		InventoryUi.remove_item("ritual_book_before")
		give_new_book()
	elif InventoryUi.using_item == "ink":
		ink_given = true
		InventoryUi.using_item = "none"
		give_new_book()
	elif InventoryUi.using_item == "the_verse":
		verse_given = true
		InventoryUi.using_item = "none"
		InventoryUi.remove_item("the_verse")
		give_new_book()
	else:
		DialogueManager.initiate_dialogue("res://dialogues/fireplace.json")

func give_ink():
	if water_given and blood_given:
		InventoryUi.add_item(get_node("/root/ACT2/office/ink"), get_node("/root/ACT2/office/ink").item_id)

func give_new_book():
	if necklace_given and book_given and ink_given and verse_given:
		InventoryUi.add_item(get_node("/root/ACT2/office/ritual_book_after"), get_node("/root/ACT2/office/ritual_book_after").item_id)
		InventoryUi.add_item(get_node("/root/ACT2/office/key"), get_node("/root/ACT2/office/key").item_id)
		fireplace_done.emit()
