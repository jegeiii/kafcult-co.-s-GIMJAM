extends RichTextLabel

var sample_text: String = "Only the worthy ones deserve heaven..."

# Test of loading the presets
var preset = preload("res://presets/normal.tres")

func _ready() -> void:
	text = apply_preset(sample_text)

func apply_preset(input_text: String) -> String:
	var result = input_text
	
	# Apply font & font size
	result = "[font={font}]".format({"font": preset.font.resource_path}) + result + "[/font]"
	result = "[font_size={size}]".format({"size": preset.font_size}) + result + "[/font_size]"
	# Apply color
	result = "[color=#{color}]".format({"color": preset.color.to_html()}) + result + "[/color]"
	# Apply outline
	result = "[outline_size={size}][outline_color=#{outline}]".format({"outline": preset.outline.to_html(), "size": preset.outline_size}) + result + "[/outline_color][/outline_size]"
	if preset.bold:
		result = "[b]" + result + "[/b]"
	if preset.italic:
		result = "[i]" + result + "[/i]"
	if preset.underline:
		result = "[u]" + result + "[/u]"
	if preset.strikethrough:
		result = "[s]" + result + "[/s]"
	
	return result



#func display_text() -> void:
	#text = "[shake][i][color=darkred]" + sample_text
	#visible_characters = 0
	#while visible_characters < sample_text.length():
		#if sample_text[visible_characters] == " ":
			#visible_characters += 1
		#else:
			#visible_characters += 1
		#
#
		#await get_tree().create_timer(0.06).timeout
