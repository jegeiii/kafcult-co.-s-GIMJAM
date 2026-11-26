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

func load_character(node: PackedScene, position: String):
	# Load the node into the scene
	var character = node.instantiate()
	add_child(character)
	
	# Set the position
	var marker = get_marker(position)
	var marker_position = get_marker_position(marker)
	character.global_position = marker_position - Vector2(
		character.size.x / 2,
		character.size.y
	)
	
	return character

# Character Resources
var CHARACTER_RESOURCES: Dictionary = {
	"William": preload("res://resource/test_sprites.tres"),
	"Diana": preload("res://resource/test_sprites.tres"),
	"Nathaniel": preload("res://resource/test_sprites.tres")
}

func get_character_resource(name):
	#return CHARACTER_RESOURCES[name]
	return preload("res://resource/test_sprites.tres")

func get_character_sprite(name, expression):
	var resource = get_character_resource(name)
	var sprite_path = resource.CHARACTER_SPRITES[expression]
	var sprite = load(sprite_path)
	return sprite

func _ready() -> void:
	# Initialize dictionary for marker
	MARKERS = {
		"left": left_marker,
		"center": center_marker,
		"right": right_marker
	}
	
	# Connect signal from DialogueManager
	DialogueManager.load_sprite.connect(_on_load_sprite)
	DialogueManager.dialogue_end.connect(_on_dialogue_end)
	DialogueManager.unload_sprite.connect(_on_unload_sprite)
	DialogueManager.highlight_speaker.connect(_on_highlight_speaker)
	DialogueManager.dialogue_start.connect(_on_dialogue_start)

# Keep track of the active characters
var active_characters: Dictionary = {}

func _on_load_sprite(name, position, expression) -> void:
	# Remove previous instance if it exists
	if active_characters.has(name):
		active_characters[name].queue_free()
		active_characters.erase(name)
		
	var character_sprite = get_character_sprite(name, expression)
	var character = load_character(character_sprite, position)
	active_characters[name] = character

func _on_unload_sprite(name) -> void:
	if active_characters.has(name):
		active_characters[name].queue_free()
		active_characters.erase(name)

func _on_highlight_speaker(name) -> void:
	for character_name in active_characters.keys():
		if character_name == name:
			active_characters[character_name].modulate = Color(1, 1, 1, 1)
		else:
			active_characters[character_name].modulate = Color(0.7, 0.7, 0.7, 1)

func _on_dialogue_start():
	visible = true

func _on_dialogue_end() -> void:
	# Remove every character that is on the screen
	for character in active_characters.values():
		character.queue_free()
		
	# Clear the dictionary
	active_characters.clear()
	visible = false
