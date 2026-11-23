extends Control

@onready var dialogue_box: PanelContainer = %DialogueBox
@onready var name_label: Label = %CharacterNameLabel
@onready var message_label: Label = %CharacterMessageLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Connect all the signals
	DialogueManager.dialogue_start.connect(_on_dialogue_start)
	DialogueManager.dialogue_end.connect(_on_dialogue_end)
	DialogueManager.load_next_line.connect(_on_load_next_line)
	
	# Initialize the dialogue box to be invisible until a dialogue is started
	dialogue_box.visible = false

func _on_dialogue_start() -> void:
	dialogue_box.visible = true

func _on_dialogue_end() -> void:
	dialogue_box.visible = false

func _on_load_next_line(name, message) -> void:
	name_label.text = name
	message_label.text = message
