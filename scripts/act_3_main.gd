extends Node2D

signal keyhole_clicked

func _on_keyhole_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				print("Area clicked!")
				keyhole_clicked.emit()


func _on_keyhole_pressed() -> void:
	print("Area clicked!")
	keyhole_clicked.emit()
