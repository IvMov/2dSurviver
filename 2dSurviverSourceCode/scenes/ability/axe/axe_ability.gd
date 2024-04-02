extends Node2D

const MAX_RADIUS = 200
@onready var hitbox_component = $HitboxComponent

var start_rotation = Vector2.RIGHT.rotated(randf()*TAU)
var player: Player


func _ready():
	player = get_tree().get_first_node_in_group("player")
	if !player:
		return
	var tween = create_tween()
	tween.tween_method(tween_method, 0.0 , 2.0, 3.0)
	tween.tween_callback(queue_free)

func tween_method(rotations: float):
	var percent = rotations / 4
	var current_radius = 10 + percent * MAX_RADIUS
	var current_direction = start_rotation.rotated(rotations * TAU)

	global_position  =  player.global_position + (current_direction * current_radius)
