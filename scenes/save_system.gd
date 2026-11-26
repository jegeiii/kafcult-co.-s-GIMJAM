extends Node

var save_data: Dictionary

func load_json(json_path: String) -> void:
	var file = FileAccess.open(json_path, FileAccess.READ)
	var text_extract = file.get_as_text()
	file.close()
	
	var json = JSON.new()
	var error = json.parse(text_extract)
	var data = json.data
	
	save_data = data

func save(current_act: String):
	save_data["current_act"] = current_act
	
	var file = FileAccess.open("res://save_state.json", FileAccess.WRITE)
	file.store_string(JSON.stringify(save_data, "\t"))
	file.close

func _ready():
	load_json("res://save_state.json")
