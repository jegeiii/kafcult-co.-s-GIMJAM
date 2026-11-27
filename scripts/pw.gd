extends VBoxContainer

@onready var correct_order: Array = ["sun", "star", "moon", "queen", "flower", "cross"]
@onready var guess_order: Array = []
signal correct
signal incorrect

func guess_pw():
	if guess_order.size() == 6:
		if guess_order == correct_order:
			correct.emit()
			print("correct")
			set_global_position(Vector2(-100,-100))
		else:
			incorrect.emit()
			print("incorrect")
		guess_order.clear()
		InventoryUi.close_inspect()
		for child in get_children():
			child.disabled = false
		visible = false

func _on_sun_pressed() -> void:
	$sun.disabled = true
	guess_order.append("sun")
	guess_pw()

func _on_star_pressed() -> void:
	$star.disabled = true
	guess_order.append("star")
	guess_pw()

func _on_moon_pressed() -> void:
	$moon.disabled = true
	guess_order.append("moon")
	guess_pw()

func _on_queen_pressed() -> void:
	$queen.disabled = true
	guess_order.append("queen")
	guess_pw()

func _on_flower_pressed() -> void:
	$flower.disabled = true
	guess_order.append("flower")
	guess_pw()

func _on_cross_pressed() -> void:
	$cross.disabled = true
	guess_order.append("cross")
	guess_pw()
	
