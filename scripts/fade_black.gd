extends ColorRect

func fade_in(duration):
	var tween = create_tween()
	tween.tween_property(self, "color:a", 0.0, duration)

func fade_out(duration):
	var tween = create_tween()
	tween.tween_property(self, "color:a", 1.0, duration)

func transparent():
	var tween = create_tween()
	tween.tween_property(self, "color:a", 0.5, 0.1)
