extends HBoxContainer

@export var sprite: Texture2D
@export var ability_name: String
@onready var label = $MarginContainer/Label

var label_blueprint: String = "DMG: %02.1f , CD: %1.2f "
var dmg: float
var cd: float

func _ready():
	update_skill_ui()
	$MarginContainer/Sprite2D.texture = sprite;

func update_skill_ui():
	if dmg == 0: 
		visible = false	
		return
	visible = true
	label.text = label_blueprint % [dmg, cd]
	
func reset_skill_ui():
	label.text = "DMG: - , CD: - "
