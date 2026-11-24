extends Control

@onready var dialogue_box: PanelContainer = %DialogueBox
@onready var name_label: Label = %CharacterNameLabel
@onready var message_label: RichTextLabel = %CharacterMessageLabel
@onready var continue_hint: TextureRect = %ContinueMarker

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Connect all the signals
	DialogueManager.dialogue_start.connect(_on_dialogue_start)
	DialogueManager.dialogue_end.connect(_on_dialogue_end)
	DialogueManager.load_next_line.connect(_on_load_next_line)
	
	# Initialize the dialogue box to be invisible until a dialogue is started
	dialogue_box.visible = false
	hide_continue_hint()

func _on_dialogue_start() -> void:
	dialogue_box.visible = true

func _on_dialogue_end() -> void:
	dialogue_box.visible = false

const PRESETS: Dictionary = {
	"normal": preload("res://resource/normal.tres"),
	"narration": preload("res://resource/narration.tres"),
	"ominous": preload("res://resource/ominous.tres"),
	"thought": preload("res://resource/thought.tres"),
	"emphasis": preload("res://resource/emphasis.tres")
}

func get_preset(style):
	return PRESETS[style]

func apply_preset(sample_text, preset) -> String:
	var result = sample_text
	
	# Apply font & font size
	result = "[font={font}]".format({"font": preset.font.resource_path}) + result + "[/font]"
	result = "[font_size={size}]".format({"size": preset.font_size}) + result + "[/font_size]"
	# Apply color
	result = "[color=#{color}]".format({"color": preset.color.to_html()}) + result + "[/color]"
	# Apply outline
	result = "[outline_size={size}][outline_color=#{outline}]".format({"outline": preset.outline.to_html(), "size": preset.outline_size}) + result + "[/outline_color][/outline_size]"
	if preset.bold:
		result = "[b]" + result + "[/b]"
	if preset.italic:
		result = "[i]" + result + "[/i]"
	if preset.underline:
		result = "[u]" + result + "[/u]"
	if preset.strikethrough:
		result = "[s]" + result + "[/s]"
	
	return result

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("continue_dialogue") and DialogueManager.dialogue_ongoing:
		if is_typing:
			skip_typing()
		else:
			DialogueManager.display_current_line()

var is_typing: bool = false
func skip_typing() -> void:
	if is_typing:
		is_typing = false

func _on_load_next_line(name, message_segments) -> void:
	# Initial state of dialogue box ig idk
	hide_continue_hint()
	name_label.text = name
	message_label.text = ""
	message_label.visible_characters = 0
	var total_characters = 0
	is_typing = true
	
	for segment in message_segments:
		# Get the base text
		var text = segment.text
		
		# Get style and apply preset
		var style = segment.style
		var preset = get_preset(style)
		var formatted_text = apply_preset(text, preset)
		message_label.append_text(formatted_text)
		
		# Load all the characters for current 
		total_characters += text.length()
		var pace = segment.pacing
		var pause_after = segment.pause_after
		while message_label.visible_characters < total_characters:
			if not is_typing:
				break
			message_label.visible_characters += 1
			await get_tree().create_timer(pace).timeout
		
		if is_typing:
			await get_tree().create_timer(pause_after).timeout
	
	# If skipped, then just reveal the entire text
	message_label.visible_characters = -1
	is_typing = false
	show_continue_hint()

func hide_continue_hint() -> void:
	continue_hint.modulate.a = 0

func show_continue_hint() -> void:
	continue_hint.modulate.a = 1
