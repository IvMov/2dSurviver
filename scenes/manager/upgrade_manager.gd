extends Node

@export var upgrade_pool: Array[AbilityUpgrade]

var current_upgrades = {
}

func _ready():
	GameEvents.call_abillity_upgrade.connect(call_abulity_upgrade_action)
	

func call_abulity_upgrade_action():
	var chosen_upgrade = upgrade_pool.pick_random() as AbilityUpgrade
	if !chosen_upgrade:
		return
	var has_upgrade = current_upgrades.has(chosen_upgrade.id)
	if !has_upgrade:
		current_upgrades[chosen_upgrade.id] = {
			"resource" : chosen_upgrade,
			"lvl": 1
		}
	else:
		current_upgrades[chosen_upgrade.id]["lvl"] += 1 
	
	print(current_upgrades)
