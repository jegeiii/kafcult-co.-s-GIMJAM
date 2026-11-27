extends Node2D

func _ready() -> void:
	print("loading act 4 end")
	DialogueManager.initiate_dialogue("res://dialogues/act_4_end.json")
	
	# Connect all the special signals
	DialogueManager.DarkScreen.connect(_on_dark_screen)
	DialogueManager.LoadBedroomWithHappyDiana.connect(_on_load_bedroom_with_happy_diana)
	DialogueManager.LoadBasementWithHappyDiana.connect(_on_load_basement_with_happy_diana)
	DialogueManager.LoadBedroomWithSadDiana.connect(_on_load_bedroom_with_sad_diana)
	DialogueManager.LoadSecretRoomWithNormalDiana.connect(_on_load_secret_room_with_normal_diana)
	DialogueManager.LoadFinalWithTheKing.connect(_on_load_final_with_the_king)
	DialogueManager.FinalFadeOut.connect(_on_final_fade_out)
func fade_in() -> void:
	%ColorRect.color.a = 1.0
	
	var tween = create_tween()
	tween.tween_property(%ColorRect, "color:a", 0.0, 1.0)
	await tween.finished

func fade_out() -> void:
	%ColorRect.color.a = 0.0
	
	var tween = create_tween()
	tween.tween_property(%ColorRect, "color:a", 1.0, 1.0)
	await tween.finished
	
func _on_dark_screen() -> void:
	$CanvasLayer/ColorRect.visible = true

func _on_load_bedroom_with_happy_diana() -> void:
	DialogueManager.disable_skipping = true
	%SceneBackgroundMain.visible = false
	%SceneBackgroundBedroom.visible = true
	%DianaHappyBedroom.visible = true
	await fade_in()
	DialogueManager.disable_skipping = false

func _on_load_basement_with_happy_diana() -> void:
	DialogueManager.disable_skipping = true
	await fade_out()
	%SceneBackgroundBedroom.visible = false
	%DianaHappyBedroom.visible = false
	%SceneBackgroundBasement.visible = true
	%DianaHappyBasement.visible = true
	await fade_in()
	DialogueManager.disable_skipping = false

func _on_load_bedroom_with_sad_diana() -> void:
	DialogueManager.disable_skipping = true
	await fade_out()
	%SceneBackgroundBasement.visible = false
	%DianaHappyBasement.visible = false
	%SceneBackgroundBedroom.visible = true
	%DianaSadBedroom.visible = true
	await fade_in()
	DialogueManager.disable_skipping = false

func _on_load_secret_room_with_normal_diana() -> void:
	DialogueManager.disable_skipping = true
	await fade_out()
	%SceneBackgroundBedroom.visible = false
	%DianaSadBedroom.visible = false
	%SceneBackgroundSecretRoom.visible = true
	%DianaNormalSecretRoom.visible = true
	await fade_in()
	DialogueManager.disable_skipping = false

func _on_load_final_with_the_king() -> void:
	DialogueManager.disable_skipping = true
	await fade_out()
	%SceneBackgroundSecretRoom.visible = false
	%DianaNormalSecretRoom.visible = false
	
	%TheKing.visible = true
	%TheKing.modulate.a = 0
	var tween = create_tween()
	tween.tween_property(%TheKing, "modulate:a", 1, 3.0)
	await tween.finished
	
	await get_tree().create_timer(3).timeout
	DialogueManager.disable_skipping = false

func _on_final_fade_out() -> void:
	DialogueManager.disable_skipping = true
	
	%TheKing.modulate.a = 1
	var tween = create_tween()
	tween.tween_property(%TheKing, "modulate:a", 0, 3.0)
	await tween.finished
	%TheKing.visible = false
	
	print("FIN")
