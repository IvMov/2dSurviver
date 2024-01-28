extends Node

const SPAWN_RADIUS = 400
const SWAPN_INTERVAL = 1

@onready var spawn_timer: Timer = $SpawnTimer
@onready var horde_timer: Timer = $HordeTimer
@export var basic_enemy_scene: PackedScene
@export var arena_time_manager: Node

func _ready():
	spawn_timer.timeout.connect(on_spawn_timer_timeout)
	spawn_timer.wait_time = SWAPN_INTERVAL;
	spawn_timer.start()
	horde_timer.timeout.connect(on_horde_timer_timeout)
	arena_time_manager.arena_difficulty_increased.connect(on_arena_difficulty_increased)
	
	
func instaintiate_enemy(player: Player):
	var enemy = basic_enemy_scene.instantiate() as Node2D
	var random_direction = get_random_direction()
	var enemy_spawn_position = player.global_position + (random_direction * SPAWN_RADIUS)
	enemy.global_position = enemy_spawn_position
	get_tree().get_first_node_in_group("entities_layer").add_child(enemy)
	EnemyCounter.add_enemy()

	
func get_random_direction():
	return Vector2.RIGHT.rotated(randf_range(0, TAU))

	
func on_spawn_timer_timeout():
	spawn_timer.start()
	
	var player = get_tree().get_first_node_in_group("player") as Player	
	if !player:
		return
	instaintiate_enemy(player)	
	

func on_horde_timer_timeout():
	var player = get_tree().get_first_node_in_group("player") as Player	
	if !player:
		return
	for n in range(PlayerCounters.current_level * 10):
		instaintiate_enemy(player)	
	

func on_arena_difficulty_increased(difficulty: int):
	spawn_timer.wait_time = SWAPN_INTERVAL - (0.03 * difficulty)
