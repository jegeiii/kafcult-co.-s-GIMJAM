extends AudioStreamPlayer

func _ready():
	#$Timer.wait_time = self.stream.get_length()
	$Timer.start()
