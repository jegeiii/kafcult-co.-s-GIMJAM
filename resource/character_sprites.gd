extends Resource
class_name CharacterSprites

@export var character_name: String
@export var character_normal: String
@export var character_happy: String
@export var character_surprised: String

var CHARACTER_SPRITES: Dictionary:
	get:
		return {
			"normal": character_normal,
			"happy": character_happy,
			"surprised": character_surprised
		}
