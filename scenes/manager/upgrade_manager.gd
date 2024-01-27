extends Node

@export var upgrade_pool: Array[AbilityUpgrade]
@export var upgrade_sreene_scene: PackedScene

var current_upgrades = {
}

func _ready():
	GameEvents.call_abillity_upgrade.connect(call_ability_upgrade_action)
	

func call_ability_upgrade_action():
	#temporary take all abilities to stack
	#var chosen_upgrade1 = upgrade_pool.pick_random() as AbilityUpgrade
	#var chosen_upgrade2 = upgrade_pool.pick_random() as AbilityUpgrade
	#if !chosen_upgrade1 || !chosen_upgrade2:
		#return
	var upgrade_screen_instance = upgrade_sreene_scene.instantiate()
	add_child(upgrade_screen_instance)
	upgrade_screen_instance.set_ability_upgrades(upgrade_pool as Array[AbilityUpgrade])
	upgrade_screen_instance.ability_upgrade_selected.connect(handle_abiliti_selected)
	
	
func apply_upgrade(upgrade: AbilityUpgrade):
	var has_upgrade = current_upgrades.has(upgrade.id)
	if !has_upgrade:
		current_upgrades[upgrade.id] = {
			"resource" : upgrade,
			"lvl": 1
		}
	else:
		current_upgrades[upgrade.id]["lvl"] += 1 
	GameEvents.emit_ability_upgrade_added(upgrade, current_upgrades)

func handle_abiliti_selected(upgrade: AbilityUpgrade):
	apply_upgrade(upgrade)
