extends CanvasLayer

@onready var progress_bar: ProgressBar = $ProgressBar
@onready var label = $ProgressBar/Label

@export var player: Player


func _ready():
	player.health_component.health_changed.connect(on_health_changed)
	on_health_changed(false)


func on_health_changed(is_hurt: bool):
	progress_bar.min_value = 0
	progress_bar.max_value = player.health_component.max_health
	progress_bar.value = player.health_component.current_health
	label.text = "HP: %3d / %3d" % [player.health_component.current_health, player.health_component.max_health]
