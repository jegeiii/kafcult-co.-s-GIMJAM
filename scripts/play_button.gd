extends Button

var next_scene = preload("res://scenes/ACT1.tscn")

func _on_pressed():
	$Timer.start()
	
func _on_timer_timeout() -> void:
	get_tree().change_scene_to_packed(next_scene)
