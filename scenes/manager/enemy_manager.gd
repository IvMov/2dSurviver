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
	enemy.global_position = get_spawn_position(player.global_position, SPAWN_RADIUS)
	get_tree().get_first_node_in_group("entities_layer").add_child(enemy)
	EnemyCounter.add_enemy()


func get_spawn_position(player_possition: Vector2, spawn_radius: int):
	var enemy_spawn_position = player_possition + (get_random_direction() * spawn_radius)
	var query_parameters = PhysicsRayQueryParameters2D.create(player_possition, enemy_spawn_position, 1) #1 - bit value of first terrain (the terrain wich we interested in to check)
	var direct_space_state = get_tree().root.world_2d.direct_space_state
	var result = direct_space_state.intersect_ray(query_parameters)
	var attempts = 0
	while !result.is_empty():
		attempts+=1
		if attempts >= 4:
			attempts = 0
			return get_spawn_position(player_possition, max(spawn_radius / 2, 2))
		enemy_spawn_position = enemy_spawn_position.rotated(PI)
		query_parameters.set_to(enemy_spawn_position)
		result = direct_space_state.intersect_ray(query_parameters)
	return enemy_spawn_position.limit_length(spawn_radius - 1)
	
	
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
