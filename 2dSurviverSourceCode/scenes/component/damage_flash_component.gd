extends Node

@export var health_component: HealthComponent
@export var sprite: Sprite2D
@export var material: ShaderMaterial

var tween: Tween
var last_hp: float

func _ready():
	health_component.health_changed.connect(on_health_changed)


func on_health_changed(is_hurt: bool):
	if tween && tween.is_valid():
			tween.kill()
	tween = create_tween()
	sprite.set_material(material)
	(sprite.material as ShaderMaterial).set_shader_parameter("lerp_precent", 0.8)
	if get_parent() is Player:
		var color = Vector3(2.0, 0.0, 0.0) if is_hurt else Vector3(0.0, 2.0, 0.0)
		(sprite.material as ShaderMaterial).set_shader_parameter("rgb", color)
	var scale_max = 1.5 if is_hurt else 1.1
	tween.tween_property(sprite, "scale", Vector2.ONE * scale_max, 0.3)
	tween.chain()
	tween.tween_property(sprite, "scale", Vector2.ONE, 0.2)
	tween.tween_property(sprite.material, "shader_parameter/lerp_precent", 0.0, .5)
	
