extends Node


@export var upgrades: Array[AbilityUpgrade]


func _ready():
	GameEvents.ability_upgrade_added.connect(on_ability_upgrad_added)
	


func on_ability_upgrad_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	var player = get_tree().get_first_node_in_group("player") as Player
	if !player: 
		return
	
	if upgrade.id == "self_movement_speed":
		player.velocity_component.max_speed = min(player.velocity_component.max_speed * (1 + (current_upgrades["self_movement_speed"]["lvl"] * upgrade.amount)), 200)
		GameEvents.emit_ability_upgrade_applied()
	elif upgrade.id == "self_hp_up":
		player.health_component.max_health += upgrade.amount
		if player.health_component.current_health + 5 > player.health_component.max_health:
			player.health_component.current_health = player.health_component.max_health;
		else: 
			player.health_component.current_health += 5;
		player.health_component.health_changed.emit(false)
		GameEvents.emit_ability_upgrade_applied()
	elif upgrade.id == "self_hp_heal":
		if player.health_component.current_health + upgrade.amount > player.health_component.max_health:
			player.health_component.current_health = player.health_component.max_health;
		else: 
			player.health_component.current_health += upgrade.amount;
		player.health_component.health_changed.emit(false)
		GameEvents.emit_ability_upgrade_applied()
	elif upgrade.id == "self_radius":
		player.collision_shape_2d.shape.radius += upgrade.amount
		GameEvents.emit_ability_upgrade_applied()
	elif upgrade.id == "self_energy_up":
		player.energy_component.increase_max_energy(upgrade.amount)
		GameEvents.emit_ability_upgrade_applied()
	elif upgrade.id == "self_energy_regen":
		player.energy_component.increase_regen(upgrade.amount)
		GameEvents.emit_ability_upgrade_applied()

