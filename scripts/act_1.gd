extends Node2D

@export var audio: Array[AudioStream] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AudioStreamPlayer.stream = audio[0]
	$AudioStreamPlayer.play()
	await $AudioStreamPlayer.finished
	$AudioStreamPlayer.stream = audio[1]
	$AudioStreamPlayer.play()
	await get_tree().create_timer(1.5).timeout
	$fade_black.fade_in(1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
