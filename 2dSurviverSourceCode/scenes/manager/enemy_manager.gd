extends Node

const SPAWN_RADIUS: = 300

const SWAPN_INTERVAL = 1.5


@onready var spawn_timer: Timer = $SpawnTimer
@onready var horde_timer: Timer = $HordeTimer
@onready var boss_timer: Timer = $BossTimer

@export var basic_enemy_scene: PackedScene
@export var wizard_scene: PackedScene

var enemy_table = WeightedTable.new()
var arena_difficulty: int


func _ready():
	spawn_timer.timeout.connect(on_spawn_timer_timeout)
	boss_timer.timeout.connect(on_boss_timer_timeout)
	spawn_timer.wait_time = SWAPN_INTERVAL;
	spawn_timer.start()
	horde_timer.timeout.connect(on_horde_timer_timeout)
	enemy_table.add_item("basic_enemy", basic_enemy_scene, 10)
	get_tree().get_first_node_in_group("arena_time_manager").arena_difficulty_increased.connect(on_arena_difficulty_increased)
	

	
func instaintiate_enemy(enemy_scene: PackedScene, player: Player):
	var enemy = enemy_scene.instantiate() as Node2D
	enemy.global_position = get_spawn_position(player.global_position, SPAWN_RADIUS)
	get_tree().get_first_node_in_group("entities_layer").add_child(enemy)
	enemy.health_component.health_bar.modulate = Color(1, 0.616, 1)
	EnemyCounter.add_enemy()
	

func instaintiate_boss(enemy_scene: PackedScene, player: Player):
	var enemy = enemy_scene.instantiate() as CharacterBody2D
	enemy.set_scale(Vector2(5,5))
	
	enemy.global_position = get_spawn_position(player.global_position, SPAWN_RADIUS)
	get_tree().get_first_node_in_group("entities_layer").add_child(enemy)
	enemy.velocity_component.max_speed = 150 + (int(PlayerCounters.current_level/2))
	enemy.health_component.max_health = 100 + (arena_difficulty * 5) + (PlayerCounters.current_level * 5)
	enemy.health_component.current_health = enemy.health_component.max_health
	enemy.health_component.update_health_bar()
	enemy.enemy_drop_component.basic_exp_drop = 20
	enemy.health_component.health_bar.modulate = Color(1, 0.616, 1)
	enemy.is_boss = true
	EnemyCounter.add_enemy()


func get_spawn_position(player_possition: Vector2, spawn_radius: int):
	var enemy_spawn_position = player_possition + (get_random_direction() * spawn_radius)
	var query_parameters = PhysicsRayQueryParameters2D.create(player_possition, enemy_spawn_position, 1) #1 - bit value of first terrain (the terrain wich we interested in to check)
	var direct_space_state = get_tree().root.world_2d.direct_space_state
	
	var result = direct_space_state.intersect_ray(query_parameters)
	var attempts = 0
	while !result.is_empty():
		attempts+=1
		if attempts >= 8:
			attempts = 0
			spawn_radius /= 2
			if spawn_radius <= 10:
				return enemy_spawn_position
			return get_spawn_position(player_possition, max(spawn_radius, 2))
		enemy_spawn_position = enemy_spawn_position.rotated(PI/4)
		query_parameters.set_to(enemy_spawn_position)
		result = direct_space_state.intersect_ray(query_parameters)
	return enemy_spawn_position
	
	
func get_random_direction():
	return Vector2.RIGHT.rotated(randf_range(0, TAU))


func on_spawn_timer_timeout():
	spawn_timer.start()
	var player = get_tree().get_first_node_in_group("player") as Player	
	if !player:
		return
	var enemy_scene = enemy_table.pick_item()
	instaintiate_enemy(enemy_scene, player)	
	

func on_horde_timer_timeout():
	var player = get_tree().get_first_node_in_group("player") as Player	
	if !player:
		return
	for n in range(PlayerCounters.current_level * 8):
		var enemy_scene = enemy_table.pick_item()
		instaintiate_enemy(enemy_scene, player)
		if(EnemyCounter.enemies > 600):
			return
	

func on_boss_timer_timeout():
	var player = get_tree().get_first_node_in_group("player") as Player	
	if !player:
		return
	var enemy_scene = enemy_table.pick_item()
	instaintiate_boss(enemy_scene, player)
	
	
func on_arena_difficulty_increased(difficulty: int):
	arena_difficulty = difficulty
	spawn_timer.wait_time = SWAPN_INTERVAL - (0.02 * difficulty)
	if difficulty == 2:
		enemy_table.add_item("wizard_enemy", wizard_scene, 1)
	elif difficulty == 10:
		enemy_table.change_item_weight("wizard_enemy", 5)
	elif difficulty == 15:
		enemy_table.change_item_weight("basic_enemy", 5)
		enemy_table.change_item_weight("wizard_enemy", 15)
	elif difficulty == 20:
		enemy_table.change_item_weight("basic_enemy", 1)
		enemy_table.change_item_weight("wizard_enemy", 10)

