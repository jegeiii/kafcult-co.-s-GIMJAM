extends Node2D

@export var audio: Array[AudioStream] = []
var i_dialogue: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	InventoryUi.written_paper_clicked.connect(_on_written_paper_clicked)
	DialogueManager.dialogue_end.connect(_on_dialogue_end)
	#$AudioStreamPlayer.stream = audio[0]
	#$AudioStreamPlayer.play()
	await get_tree().create_timer(0.5).timeout
	DialogueManager.initiate_dialogue("res://dialogues/act_1_part_1.json")
	#AudioManager.play_sfx("res://audio/act1_1.wav")
	#$AudioStreamPlayer.stream = audio[1]
	#$AudioStreamPlayer.play()
	await get_tree().create_timer(1.5).timeout
	$fade_black.fade_in(1)

func _on_dialogue_end():
	i_dialogue += 1
	if i_dialogue >= 2:
		GameManager.change_act_to(2)
		
func _on_written_paper_clicked():
	DialogueManager.initiate_dialogue("res://dialogues/act_1_part_2.json")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
