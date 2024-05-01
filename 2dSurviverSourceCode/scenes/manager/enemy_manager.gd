extends Node

const SPAWN_RADIUS: = 325
const HORDE_SPAWN_RADIUS: = 280

const SWAPN_INTERVAL = 1.5


@onready var spawn_timer: Timer = $SpawnTimer
@onready var horde_timer: Timer = $HordeTimer
@onready var boss_timer: Timer = $BossTimer

@export var green_enemy_scene: PackedScene
@export var wizard_enemy_scene: PackedScene
@export var cyclop_enemy_scene: PackedScene
@export var ranged_wizard_enemy_scene: PackedScene


var enemy_table = WeightedTable.new()
var arena_difficulty: int
var enemies_per_spaun: int = 1
var enemies: int = 0
var enemy_health_bonus: float = 0
var game_difficulty: int = PlayerCounters.game_difficulty

func _ready():
	spawn_timer.timeout.connect(on_spawn_timer_timeout)
	boss_timer.timeout.connect(on_boss_timer_timeout)
	spawn_timer.wait_time = SWAPN_INTERVAL;
	spawn_timer.start()
	horde_timer.timeout.connect(on_horde_timer_timeout)
	enemy_table.add_item("green_enemy", green_enemy_scene, 10)
	get_tree().get_first_node_in_group("arena_time_manager").arena_difficulty_increased.connect(on_arena_difficulty_increased)
	

	
func instaintiate_enemy(enemy_scene: PackedScene, player: Player, spawn_radius):
	var enemy: CharacterBody2D = enemy_scene.instantiate()
	
	enemy.global_position = get_spawn_position(player.global_position, spawn_radius)
	get_tree().get_first_node_in_group("entities_layer").add_child(enemy)
	
	if game_difficulty > 1:
		enemy.health_component.max_health+= enemy_health_bonus*2
	else:
		enemy.health_component.max_health+= enemy_health_bonus
	enemy.health_component.current_health = enemy.health_component.max_health
	enemies+=1
	

func instaintiate_boss(enemy_scene: PackedScene, player: Player):
	var enemy: CharacterBody2D = enemy_scene.instantiate()
	
	enemy.global_position = get_spawn_position(player.global_position, SPAWN_RADIUS)
	get_tree().get_first_node_in_group("entities_layer").add_child(enemy)
	enemy.set_is_boss(100, 200)
	enemies+=1


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
	if enemies - PlayerCounters.run_kills >= 250:
		return
	var player = get_tree().get_first_node_in_group("player") as Player	
	if !player:
		return
	var enemy_scene = enemy_table.pick_item()
	for i in enemies_per_spaun:
		instaintiate_enemy(enemy_scene, player, SPAWN_RADIUS)	
	
	

func on_horde_timer_timeout():
	var player = get_tree().get_first_node_in_group("player") as Player	
	if !player:
		return
	for n in range(20 + arena_difficulty):
		var enemy_scene = enemy_table.pick_item()
		instaintiate_enemy(enemy_scene, player, HORDE_SPAWN_RADIUS)
		if(enemies - PlayerCounters.run_kills > 250):
			return
	

func on_boss_timer_timeout():
	var player = get_tree().get_first_node_in_group("player") as Player	
	if !player:
		return
	var enemy_scene = enemy_table.pick_item()
	instaintiate_boss(enemy_scene, player)
	if arena_difficulty >= 60 && boss_timer.wait_time != 11:
		boss_timer.wait_time= max(11, boss_timer.wait_time-5)
		boss_timer.start()
	
	
func on_arena_difficulty_increased(difficulty: int):
	arena_difficulty = difficulty
	spawn_timer.wait_time = max(0.3, SWAPN_INTERVAL - (0.02 * difficulty))
	match difficulty:
		5: 
			enemy_table.add_item("cyclop_enemy", cyclop_enemy_scene, 1)
			enemy_table.change_item_weight("green_enemy", 9)
			
		10:
			enemy_table.add_item("wizard_enemy", wizard_enemy_scene, 1)
			enemy_table.change_item_weight("green_enemy", 8)
			enemies_per_spaun+=1
		15:
			enemy_table.add_item("ranged_wizard_enemy", ranged_wizard_enemy_scene, 1)
			enemy_table.change_item_weight("green_enemy", 4)
			enemy_table.change_item_weight("wizard_enemy", 4)
			enemy_health_bonus= PlayerCounters.current_level * 1 * game_difficulty
		20:
			enemy_table.change_item_weight("green_enemy", 2)
			enemy_table.change_item_weight("wizard_enemy", 6)
			enemies_per_spaun+=1
		30: 
			enemy_table.change_item_weight("wizard_enemy", 2)
			enemy_table.change_item_weight("ranged_wizard_enemy", 3)
			enemy_table.change_item_weight("cyclop_enemy", 3)
			enemy_health_bonus= PlayerCounters.current_level * 1.5 * game_difficulty
		45: 
			enemy_table.change_item_weight("green_enemy", 1)
			enemy_table.change_item_weight("ranged_wizard_enemy", 6)
			enemy_table.change_item_weight("cyclop_enemy", 6)
			enemies_per_spaun+=1
			enemy_health_bonus= PlayerCounters.current_level * 2 * game_difficulty
		50:
			enemy_table.change_item_weight("wizard_enemy", 1)
		60:
			enemies_per_spaun+=game_difficulty
			enemy_health_bonus = PlayerCounters.current_level * 4 * game_difficulty
			
			

