extends Node

# Keep track of the current act
var current_act: int = 1

func change_act_to(act_number: int) -> void:
	current_act = act_number
	var next_scene: PackedScene = load("res://scenes/ACT"+ str(act_number) +".tscn")
	
	InventoryUi.fade_out(1)
	await get_tree().create_timer(1.5).timeout
	get_tree().change_scene_to_packed(next_scene)
	InventoryUi.fade_in(1)

# Items collected by the player
# Store item_id and their quantities
var inventory: Dictionary = {}

# Default ammount to check
func add_item(item_id: String, amount: int = 1) -> void:
	inventory[item_id] = inventory.get(item_id, 0) + amount
	print("Obtained: ", item_id)

func remove_item(item_id: String, amount: int = 1) -> void:
	if not inventory.has(item_id):
		return

	inventory[item_id] -= amount

	if inventory[item_id] <= 0:
		inventory.erase(item_id)

	print("Removed: ", item_id)

func has_item(item_id: String, amount: int = 1) -> bool:
	return inventory.get(item_id, 0) >= amount

func get_item_count(item_id: String) -> int:
	return inventory.get(item_id, 0)

# Track the task the player has done
var task_flags: Dictionary = {
	1: {
		"read_envelope": false,
	},
	2: {
		"get_charles's_key": false,
		"cut_rotten_meat": false,
		"cut_rotten_vegetable": false,
		"offering_to_silhouette": false,
		"give_dog_food": false,
		"give_dog_water": false,
		"give_dog_toy": false,
		"give_dog_pet": false,
		"deciphered_code": false,
		"rip_painting": false,
	},
	3: {
		"find_secret_room": false
	},
	4: {
		"procedure_1": false,
		"procedure_2": false,
		"procedure_3": false,
		"procedure_4": false
	}
}

func complete_task(act_number: int, task_flag: String) -> void:
	if(task_flags.has(act_number)):
		if(task_flags[act_number].has(task_flag)):
			task_flags[act_number][task_flag] = true
			print("Task completed: ", task_flag)

func check_task_status(act_number: int, task_flag: String) -> bool:
	return task_flags.get(act_number, {}).get(task_flag, false)
