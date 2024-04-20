extends Node

const MAX_RENGE = 80

@export var sword_dmg: MetaUpgrade
@export var sword_ability: PackedScene
@export var upgrades: Array[AbilityUpgrade]
@onready var ability_timer = %AbilityTimer
@onready var audio_stream_player = $AudioStreamPlayer

var controller_name = "Sword"
var base_damage: int
var damage: float
var scale_factor = 1
var base_wait_time: float


# Called when the node enters the scene tree for the first time.
func _ready():
	calculate_base_damage()
	base_wait_time = ability_timer.wait_time
	ability_timer.timeout.connect(action_on_timer_timeout)
	GameEvents.ability_upgrade_added.connect(on_ability_upgrad_added)

func action_on_timer_timeout():
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if !player: 
		return
		
	var enemies = get_tree().get_nodes_in_group("enemy")
	enemies = enemies.filter(func(enemy: Node2D):
		return enemy.global_position.distance_squared_to(player.global_position) < pow(MAX_RENGE, 2)
	)
	if enemies.size() == 0:
		return
	enemies.sort_custom(func(a: Node2D, b: Node2D):
		var a_distance = a.global_position.distance_squared_to(player.global_position)
		var b_distance = b.global_position.distance_squared_to(player.global_position)
		return a_distance < b_distance
	)
	
	var sword_instance = sword_ability.instantiate() as SwordAbility	
	audio_stream_player.play()
	get_tree().get_first_node_in_group("foreground_layer").add_child(sword_instance)
	sword_instance.scale_factor = scale_factor
	sword_instance.hitbox_component.damage = damage
	sword_instance.global_position = enemies[0].global_position 
	sword_instance.global_position += Vector2.RIGHT.rotated(randf_range(0, TAU)) * 4 
	
	var enemy_direction = enemies[0].global_position - sword_instance.global_position as Vector2
	sword_instance.rotation = enemy_direction.angle()

func calculate_base_damage():
	var current_lvl = MetaProgression.meta_data["upgrades"][sword_dmg.id]["lvl"]
	base_damage = sword_dmg.base + (sword_dmg.value * current_lvl)
	damage = base_damage

		
func rescale_audio():
	if ability_timer.wait_time < .1:
		audio_stream_player.pitch_scale = 1.4
	elif ability_timer.wait_time < .2:
		audio_stream_player.pitch_scale = 1.1
	elif ability_timer.wait_time < .35:
		audio_stream_player.pitch_scale = 0.9
	else: 
		audio_stream_player.pitch_scale = 0.7

func on_ability_upgrad_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	if upgrade.id == "sword_rate":
		var percent_improve = current_upgrades["sword_rate"]["lvl"] * upgrade.amount
		ability_timer.wait_time = max(base_wait_time - percent_improve, 0.05)
		rescale_audio()
		ability_timer.start()
		GameEvents.emit_ability_upgrade_applied()
	elif upgrade.id == "sword_damage":
		damage *= 1 + upgrade.amount
		GameEvents.emit_ability_upgrade_applied()
	elif upgrade.id == "sword_size":
		scale_factor = min(scale_factor + 1, 4)
		GameEvents.emit_ability_upgrade_applied()

		
