extends CanvasLayer

@onready var color_rect = $ColorRect

var base_opacity = 0.3
func _ready():
	GameEvents.player_damaged.connect(on_player_damaged)
	

func on_player_damaged(value: int):

	var tween = create_tween().set_parallel(true)
	tween.tween_property(color_rect, "material:shader_parameter/vignette_opacity", min(1, base_opacity + (base_opacity*value)/2), 0.3)
	tween.tween_property(color_rect, "material:shader_parameter/vignette_rgb", Color(0.98, 0.11, 0.11, 1), 0.3)
	tween.chain()
	tween.tween_property(color_rect, "material:shader_parameter/vignette_rgb", Color(0.24, 0.11, 0.19, 1), 0.2)
	tween.tween_property(color_rect, "material:shader_parameter/vignette_opacity", 0.3, 0.2)
	
