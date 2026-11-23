extends Resource
class_name TextPreset

@export_group("Typography")
@export var font: Font
@export var font_size: int
@export var color: Color

@export_group("Formatting")
@export var bold: bool
@export var italic: bool
@export var underline: bool
@export var strikethrough: bool

@export_group("Outline")
@export var outline: Color
@export var outline_size: int
