extends TextureButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var bitmap := BitMap.new()
	bitmap.create_from_image_alpha(texture_normal.get_image())
	texture_click_mask = bitmap

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
