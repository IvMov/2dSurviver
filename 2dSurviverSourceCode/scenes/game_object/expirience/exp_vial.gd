extends Node2D

var VALUE: int

@onready var collision_shape_2d = $Area2D/CollisionShape2D
@onready var animation_player = $AnimationPlayer
@onready var sprite_2d = $Sprite2D

func _ready():
	$Area2D.area_entered.connect(on_area_entered)
	if VALUE > 200:
		sprite_2d.texture = (load("res://scenes/game_object/expirience/exp_vial_tier4.png"))
	elif VALUE > 150:
		sprite_2d.texture = (load("res://scenes/game_object/expirience/exp_vial_tier3.png"))
	elif VALUE > 100:
		sprite_2d.texture = (load("res://scenes/game_object/expirience/exp_vial_tier2.png"))
	else:
		pass
	


func tween_collect(percent: float, start_position: Vector2):
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if !player:
		return
	
	global_position = start_position.lerp(player.global_position, percent)

func collect():
		GameEvents.emit_exp_collected(VALUE, global_position)
		queue_free()


func disable_collision():
	collision_shape_2d.disabled = true
	
func on_area_entered(other_area: Area2D):
	animation_player.play("moving")
	Callable(disable_collision).call_deferred()
	
	var tween = create_tween()
	tween.tween_method(tween_collect.bind(global_position), 0.0, 1.0, .8)\
		.set_ease(Tween.EASE_IN)\
		.set_trans(Tween.TRANS_BACK)
	tween.tween_callback(collect)
