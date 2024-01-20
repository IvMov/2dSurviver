extends CharacterBody2D

const MAX_SPEED = 50
var EXP = 10 * get_random_factor(1,3)
var COINS = get_random_factor(1, 5)


# Called when the node enters the scene tree for the first time.
func _ready():
	$Area2D.area_entered.connect(on_area_2d_area_entered)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var direction = get_direction_to_player()
	velocity = direction * (MAX_SPEED * get_random_factor(0.2, 2))
	move_and_slide()


func get_direction_to_player():
	var player_nodes = get_tree().get_first_node_in_group("player") as Node2D
	if player_nodes != null:
		return (player_nodes.global_position - global_position).normalized()
	return Vector2.ZERO	


func on_area_2d_area_entered(area):
	GameEvents.emit_exp_dropped(EXP, global_position)
	# 0.8 ->  20% chance of drop the coin
	if get_random_factor(0, 1) > 0.8: 
		GameEvents.emit_coin_dropped(COINS, global_position)
	queue_free()
	# TODO: Remove after will add normal events
	EnemyCounter.minus_enemy()


func get_random_factor(min:int, max:int):
	var rng = RandomNumberGenerator.new()
	return rng.randf_range(min, max)
