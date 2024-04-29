extends Node2D

var VALUE: int

@onready var sprite_2d = $Sprite2D
@onready var collision_shape_2d = $Area2D/CollisionShape2D
@onready var animation_player = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	$Area2D.area_entered.connect(on_area_entered)
	if VALUE > 10:
		scale = Vector2.ONE * 1.2
		sprite_2d.texture = load("res://assets/game_objects/dropable/coin2.png")

	
func tween_collect(percent: float, start_position: Vector2):
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if !player:
		return
	
	global_position = start_position.lerp(player.global_position, percent)
	

func collect():
		GameEvents.emit_coin_collected(VALUE, global_position)
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
