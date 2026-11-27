extends Node

@export var hover_tint: Color = Color(0.85, 0.85, 0.85, 1.0)
@export var pressed_tint: Color = Color(0.65, 0.65, 0.65, 1.0)
@onready var parent_button: TextureButton = get_parent()

func _ready():
	parent_button.mouse_entered.connect(_on_clickables_mouse_entered)
	parent_button.mouse_exited.connect(_on_clickables_mouse_exited)
	parent_button.button_down.connect(_on_clickables_button_down)

func _on_clickables_mouse_entered() -> void:
	parent_button.self_modulate = hover_tint

func _on_clickables_mouse_exited() -> void:
	parent_button.self_modulate = Color.WHITE

func _on_clickables_button_down() -> void:
	parent_button.self_modulate = pressed_tint
