extends TextureButton

@export var item_id = "placeholder"
@export var button_interaction = "get" #get or interact

func _ready():
	InventoryUi.fade_black_pressed.connect(_on_root_fade_black_gui_input)
	print(item_id)

func _on_pressed():
	print("pressed")
	#print("pressed: ", interaction)
	if button_interaction == "get":
		button_interaction = "inventory"
		self_modulate.a = 0.0
		$notification.text = "Obtained " + item_id
		$notification.visible = true
		$notification/Timer.start()
		disabled = false
		InventoryUi.add_item(self)
	elif button_interaction == "inspect":
		disabled = true
		$fade_black.transparent()
		$fade_black.mouse_filter = MOUSE_FILTER_STOP
		$item_closeup.visible = true
	elif button_interaction == "inventory":
		pass
		#disabled = true
		#InventoryUi.InventoryInspect(item_id)

func _on_timer_timeout() -> void:
	$notification.visible = false

func _on_fade_black_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("LMB"):
		#print("overlay clicked")
		$item_closeup.visible = false
		$fade_black.fade_in(0.1)
		set_deferred("disabled", false)
		$fade_black.mouse_filter = MOUSE_FILTER_IGNORE

func _on_root_fade_black_gui_input():
	set_deferred("disabled", false)
