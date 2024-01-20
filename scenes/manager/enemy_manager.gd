extends Node

const SPAWN_RADIUS = 400

@export var basic_enemy_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.timeout.connect(on_timeout)
	

func on_timeout():
	var player = get_tree().get_first_node_in_group("player") as Node2D	
	if !player:
		return
		
	var enemy = basic_enemy_scene.instantiate() as Node2D	
	var random_direction = get_random_direction();
	var enemy_spawn_position = player.global_position + (random_direction * SPAWN_RADIUS)
	
	enemy.global_position = enemy_spawn_position
	get_parent().add_child(enemy)
	EnemyCounter.add_enemy()
	
	
func get_random_direction():
	return Vector2.RIGHT.rotated(randf_range(0, TAU))
