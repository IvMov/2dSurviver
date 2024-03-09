extends Node


@export var upgrades: Array[AbilityUpgrade]


func _ready():
	GameEvents.ability_upgrade_added.connect(on_ability_upgrad_added)


func on_ability_upgrad_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if !player: 
		return
	
	if upgrade.id == "self_movement_speed":
		player.current_speed = player.BASIC_SPEED * (1 + (current_upgrades["self_movement_speed"]["lvl"] * upgrade.amount))
	if upgrade.id == "self_hp_up":
		player.health_component.max_health += upgrade.amount
		player.health_component.update_health_bar()
	if upgrade.id == "self_hp_heal":
		if player.health_component.current_health + upgrade.amount > player.health_component.max_health:
			player.health_component.current_health = player.health_component.max_health;
		else: 
			player.health_component.current_health += upgrade.amount;
		player.health_component.update_health_bar()
		
