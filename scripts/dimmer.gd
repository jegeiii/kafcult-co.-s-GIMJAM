extends Node

@export var hover_tint: Color = Color(0.85, 0.85, 0.85, 1.0)
@export var pressed_tint: Color = Color(0.65, 0.65, 0.65, 1.0)
@onready var parent_button: TextureButton = get_parent()
@export var condition: String = "none"
@export var is_conditional: bool = false

func _ready():
	parent_button.mouse_entered.connect(_on_clickables_mouse_entered)
	parent_button.mouse_exited.connect(_on_clickables_mouse_exited)
	parent_button.button_down.connect(_on_clickables_button_down)

func _on_clickables_mouse_entered() -> void:
	if is_conditional:
		if condition == InventoryUi.using_item:
			parent_button.self_modulate = hover_tint
	else:
		parent_button.self_modulate = hover_tint
	
func _on_clickables_mouse_exited() -> void:
	if is_conditional:
		if condition == InventoryUi.using_item:
			parent_button.self_modulate = Color.WHITE
	else:
		parent_button.self_modulate = Color.WHITE

func _on_clickables_button_down() -> void:
	if is_conditional:
		if condition == InventoryUi.using_item:
			parent_button.self_modulate = pressed_tint
	else:
		parent_button.self_modulate = pressed_tint
