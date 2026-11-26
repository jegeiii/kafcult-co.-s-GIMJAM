extends Node2D

@export var audio: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AudioStreamPlayer.stream = audio["act1_1"]
	$AudioStreamPlayer.play()
	$AudioStreamPlayer.stream = audio["act1_2"]
	$AudioStreamPlayer.play()
	await $AudioStreamPlayer.finished
	$fade_black.fade_in(1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
