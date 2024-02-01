extends Node

@export var axe_ability_scene: PackedScene

var damage = 10

func _ready():
	$Timer.timeout.connect(on_timer_timeout)
	$Timer.wait_time = 1
	$Timer.start()
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
	pass
