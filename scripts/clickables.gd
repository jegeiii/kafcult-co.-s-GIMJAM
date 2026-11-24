extends Button

@export var item_id = "placeholder"

func _ready():
	print(item_id)

func _on_pressed(interaction):
	disabled = true
	#print("pressed: ", interaction)
	if interaction == "get":
		self_modulate.a = 0.0
		$notification.text = "Obtained " + item_id
		$notification.visible = true
		$notification/Timer.start()
		InventoryManager.add_item(item_id)
	elif interaction == "inspect":
		$fade_black.transparent()
		$fade_black.mouse_filter = MOUSE_FILTER_STOP
		$item_closeup.visible = true

func _on_timer_timeout() -> void:
	$notification.visible = false

func _on_fade_black_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("LMB"):
		#print("overlay clicked")
		$item_closeup.visible = false
		$fade_black.fade_in(0.1)
		set_deferred("disabled", false)
		$fade_black.mouse_filter = MOUSE_FILTER_IGNORE
		
