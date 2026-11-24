extends Control

# Reference points
@onready var left_marker: Control = %LeftMarker
@onready var center_marker: Control = %CenterMarker
@onready var right_marker: Control = %RightMarker
var MARKERS: Dictionary

func get_marker(position: String) -> Control:
	return MARKERS[position]	

func get_marker_position(marker: Control) -> Vector2:
	return marker.global_position

func load_character(node: PackedScene, position: String) -> void:
	# Load the node into the scene
	var character = node.instantiate()
	add_child(character)
	
	# Set the position
	var marker = get_marker(position)
	var marker_position = get_marker_position(marker)
	character.global_position = marker_position - Vector2(
		$WilliamHappySprite.size.x / 2,
		$WilliamHappySprite.size.y
	)

func _ready() -> void:
	# Initialize dictionary for marker
	MARKERS = {
		"left": left_marker,
		"center": center_marker,
		"right": right_marker
	}
	await get_tree().process_frame


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
