extends Node

const SPAWN_RADIUS = 10
@export_range(0, 1) var coin_drop_chance: float = 0.2

@export var coin: PackedScene
@export var exp_vial: PackedScene
@export var health_component: Node

var EXP = 10 * ceil(randf()*10)
var COINS = ceil(randf()*10)


func _ready():
	(health_component as HealthComponent).died.connect(on_dead_drop)
	
	
func on_exp_drop(value, position):
	var exp_inst = exp_vial.instantiate() as Node2D
	exp_inst.global_position = position + (get_random_direction() * SPAWN_RADIUS)
	exp_inst.rotate(randf_range(0, TAU))
	exp_inst.VALUE = value
	Callable(instantiate_child).bind(exp_inst).call_deferred()
	
	
func on_coin_drop(value, position):
	var coin_inst = coin.instantiate() as Node2D
	coin_inst.global_position = position + (get_random_direction() * SPAWN_RADIUS)
	coin_inst.rotate(randf_range(0, TAU))
	coin_inst.VALUE = value
	Callable(instantiate_child).bind(coin_inst).call_deferred()

func on_dead_drop():
	EnemyCounter.minus_enemy()
	
	on_exp_drop(EXP, get_parent().global_position)
	if randf() > 1 - coin_drop_chance: 
		on_coin_drop(COINS, get_parent().global_position)
	
	
func instantiate_child(inst: Node2D):
	get_tree().root.add_child(inst)
	
	
func get_random_direction():
	return Vector2.RIGHT.rotated(randf_range(0, TAU))