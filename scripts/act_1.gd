extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#$act1_audio.play()
	SaveSystem.save("res://scenes/ACT1.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
