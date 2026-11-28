extends Control

@onready var dialogue_box: PanelContainer = %DialogueBox
@onready var name_label: Label = %CharacterNameLabel
@onready var message_label: RichTextLabel = %CharacterMessageLabel
@onready var continue_hint: TextureRect = %ContinueMarker

var is_typing: bool = false
var _text_generation: int = 0

func _ready() -> void:
	DialogueManager.dialogue_start.connect(_on_dialogue_start)
	DialogueManager.dialogue_end.connect(_on_dialogue_end)
	DialogueManager.load_text.connect(_on_load_text)
	
	dialogue_box.visible = false
	hide_continue_hint()

func _on_dialogue_start() -> void:
	dialogue_box.visible = true
	visible = true

func _on_dialogue_end() -> void:
	dialogue_box.visible = false
	visible = false

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
	
	result = "[font={font}]".format({"font": preset.font.resource_path}) + result + "[/font]"
	result = "[font_size={size}]".format({"size": preset.font_size}) + result + "[/font_size]"
	result = "[color=#{color}]".format({"color": preset.color.to_html()}) + result + "[/color]"
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

func _input(event: InputEvent) -> void:
	if not is_visible_in_tree():
		return
	if event.is_action_pressed("continue_dialogue") and not event.is_echo() and DialogueManager.dialogue_ongoing and !DialogueManager.flashback_transition and !DialogueManager.disable_skipping:
		get_viewport().set_input_as_handled()
		if is_typing:
			print("skip1")
			skip_typing()
		else:
			DialogueManager.dialogue_next()

func skip_typing() -> void:
	is_typing = false

func _on_load_text(name, message_segments) -> void:
	if not is_visible_in_tree():
		return
	_text_generation += 1
	var my_gen = _text_generation
	
	hide_continue_hint()
	name_label.text = name
	message_label.text = ""
	message_label.visible_characters = 0
	var total_characters = 0
	is_typing = true
	
	for segment in message_segments:
		var preset = get_preset(segment.style)
		message_label.append_text(apply_preset(segment.text, preset))
	
	for segment in message_segments:
		if not is_typing or my_gen != _text_generation:
			break
			
		total_characters += segment.text.length()
		var pace = segment.pacing
		var pause_after = segment.pause_after
		
		while message_label.visible_characters < total_characters:
			if not is_typing or my_gen != _text_generation:
				break
			message_label.visible_characters += 1
			await get_tree().create_timer(pace).timeout
			if my_gen != _text_generation:
				return
		
		if is_typing and pause_after > 0.0:
			await get_tree().create_timer(pause_after).timeout
			if my_gen != _text_generation:
				return
	
	if my_gen == _text_generation:
		message_label.visible_characters = -1
		is_typing = false
		show_continue_hint()

func hide_continue_hint() -> void:
	continue_hint.modulate.a = 0

func show_continue_hint() -> void:
	continue_hint.modulate.a = 1
