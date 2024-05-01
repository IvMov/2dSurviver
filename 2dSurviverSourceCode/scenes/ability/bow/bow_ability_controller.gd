extends Node


@export var bow_dmg: MetaUpgrade
@export var bow_arrow_scene: PackedScene
@export var upgrades: Array[AbilityUpgrade]
@onready var ability_timer = %AbilityTimer
@onready var audio_stream_player = $AudioStreamPlayer
@onready var shoot_timer = $ShootTimer

@onready var player = get_tree().get_first_node_in_group("player") as Player
@onready var projectile_layer = get_tree().get_first_node_in_group("projectiles_layer")
@onready var enemies = get_tree().get_nodes_in_group("enemy")

var controller_name = "Bow"
var base_damage: int
var damage: float
var arrow_speed: int = 250
var base_wait_time: float
var arrows_per_shot: int = 1
var shots_per_shot: int = 1
var arrow_life_time: float = 2
var energy_cost: float = 5

func _ready():
	var arrow = load("res://assets/ui/mouse_shot.png")
	Input.set_custom_mouse_cursor(arrow)
	
	calculate_base_damage()
	ability_timer.wait_time = 3
	
	shoot_timer.timeout.connect(on_shoot_timer_timeout)
	ability_timer.timeout.connect(on_ability_timer_timeout)
	
	ability_timer.start()
	base_wait_time = ability_timer.wait_time
	GameEvents.ability_upgrade_added.connect(on_ability_upgrad_added)
	
func _unhandled_input(event):
	if event.is_action("left_click") && event.is_pressed() && player.energy_component.minus_energy(energy_cost):
		shot_in_direction(player.get_global_transform_with_canvas().origin, event.position)

func calculate_base_damage():
	var current_lvl = MetaProgression.meta_data["upgrades"][bow_dmg.id]["lvl"]
	base_damage = bow_dmg.base + (bow_dmg.value * current_lvl)	
	damage = base_damage


func rescale_audio():
	if ability_timer.wait_time < .3:
		audio_stream_player.pitch_scale = 1.2
	elif ability_timer.wait_time < .6:
		audio_stream_player.pitch_scale = 1
	else: 
		audio_stream_player.pitch_scale = 0.8


func on_ability_timer_timeout():
	shoot()


func shoot():
	if !player || !projectile_layer: 
		return
	enemies = get_tree().get_nodes_in_group("enemy")
	if enemies.is_empty():
		return
	for shot in shots_per_shot:	
		shoot_timer.start()
		await shoot_timer.timeout
			

func on_shoot_timer_timeout():
	enemies = get_tree().get_nodes_in_group("enemy")
	var enemy: BasicEnemy = enemies.pick_random()
	shot_in_direction(player.global_position, enemy.global_position)
	

func shot_in_direction(start: Vector2, target: Vector2):
	audio_stream_player.play()
	for arrow in arrows_per_shot:
		var projectile: PlayerProjectile = bow_arrow_scene.instantiate() 
		projectile.damage = damage
		projectile.life_time = arrow_life_time
		projectile.speed  = arrow_speed
		projectile_layer.add_child(projectile)
		projectile.global_position = player.global_position
		
		projectile.direction = (target - start).normalized()
		
		if arrows_per_shot > 1 && arrow != 0:
			projectile.direction = projectile.direction.rotated(randf_range(-0.2, 0.2))
		projectile.rotate(projectile.direction.angle())

func on_ability_upgrad_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	match upgrade.id:
		"bow_dmg":
			damage *= 1 + upgrade.amount
			GameEvents.emit_ability_upgrade_applied()
		"bow_rate":
			var percent_improve = current_upgrades["bow_rate"]["lvl"] * upgrade.amount
			ability_timer.wait_time = max(base_wait_time - percent_improve, 1.0)
			ability_timer.start()
			rescale_audio()
			GameEvents.emit_ability_upgrade_applied()
		"bow_arrows":
			arrows_per_shot+=int(upgrade.amount)
			GameEvents.emit_ability_upgrade_applied()
		"bow_shots":
			shots_per_shot+=int(upgrade.amount)
			GameEvents.emit_ability_upgrade_applied()
