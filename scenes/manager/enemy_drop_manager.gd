extends Node

const SPAWN_RADIUS = 10

@export var coin: PackedScene
@export var exp_vial: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	GameEvents.exp_dropped.connect(on_exp_drop)
	GameEvents.coin_dropped.connect(on_coin_drop)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
	
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
	
func instantiate_child(inst: Node2D):
	get_parent().add_child(inst)
	
	
func get_random_direction():
	return Vector2.RIGHT.rotated(randf_range(0, TAU))
