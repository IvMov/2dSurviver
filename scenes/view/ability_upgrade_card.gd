extends PanelContainer

signal card_selected

@onready var header_label: Label = %Header
@onready var description_label: Label = %Description

func _ready():
	gui_input.connect(on_gui_input)

func set_ability_upgrade(upgrade: AbilityUpgrade):
	header_label.text = upgrade.name
	description_label.text = upgrade.description
	

func on_gui_input(event: InputEvent):
	if event.is_action_pressed("left_click"):
		card_selected.emit()
		get_tree().paused = false
		queue_free()
