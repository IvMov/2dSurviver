extends Node

const SPAWN_RADIUS = 10
@export_range(0, 1) var coin_drop_chance: float

@export var coin: PackedScene
@export var exp_vial: PackedScene
@export var health_component: Node
@export var basic_exp_drop: int
@onready var enemy_manager = get_tree().get_first_node_in_group("enemy_manager")

var EXP: int
var COINS_BASE: int = 10
var COINS: int


func _ready():
	EXP = PlayerCounters.current_level + (basic_exp_drop * ceil(2 + (randf()*8)))
	COINS = ceil(randf()*COINS_BASE)
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
	on_exp_drop(EXP, get_parent().global_position)
	if randf() <= coin_drop_chance: 
		on_coin_drop(COINS, get_parent().global_position)
	
	
func instantiate_child(inst: Node2D):
	get_tree().get_first_node_in_group("entities_layer").add_child(inst)
	
	
func get_random_direction():
	return Vector2.RIGHT.rotated(randf_range(0, TAU))

