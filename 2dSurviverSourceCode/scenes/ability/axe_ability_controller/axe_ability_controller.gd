extends Node

@export var axe_ability_scene: PackedScene
@export var upgrades: Array[AbilityUpgrade]

var damage = 7
var base_wait_tile: float

func _ready():
	$Timer.timeout.connect(on_timer_timeout)
	$Timer.wait_time = 2
	$Timer.start()
	base_wait_tile = $Timer.wait_time
	GameEvents.ability_upgrade_added.connect(on_ability_upgrad_added)
	

func on_timer_timeout():
	var player = get_tree().get_first_node_in_group("player") as Player
	if !player: 
		return
	
	var foreground = get_tree().get_first_node_in_group("foreground_layer")
	if !foreground:
		return
	
	var axe_instance = axe_ability_scene.instantiate() as Node2D
	foreground.add_child(axe_instance)
	axe_instance.global_position = player.global_position
	axe_instance.hitbox_component.damage = damage

func on_ability_upgrad_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	print(base_wait_tile)
	if upgrade.id == "axe_rate":
		var percent_improve = current_upgrades["axe_rate"]["lvl"] * .05
		$Timer.wait_time = max(base_wait_tile * (1 - percent_improve), 0.01)
		$Timer.start()
		print($Timer.wait_time)
	if upgrade.id == "axe_dmg":
		var percent_improve = current_upgrades["axe_dmg"]["lvl"] * .05
		damage += damage * percent_improve
		print(damage)
