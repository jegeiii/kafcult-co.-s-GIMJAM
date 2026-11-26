extends Button

var next_scene

func _ready():
	next_scene = load(SaveSystem.save_data["current_act"])

func _on_pressed():
	$Timer.start()
	
func _on_timer_timeout() -> void:
	get_tree().change_scene_to_packed(next_scene)
