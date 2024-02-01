extends Node

const MAX_LVL = 15

@export var upgrade_pool: Array[AbilityUpgrade]
@export var upgrade_sreene_scene: PackedScene

var current_upgrades = {
}

func _ready():
	GameEvents.call_abillity_upgrade.connect(call_ability_upgrade_action)


func pick_upgrades() :
	var upgrades = upgrade_pool.duplicate()
	var chosen_upgrades: Array[AbilityUpgrade] = []
	for i in 2:
		var chosen_upgrade = upgrades.pick_random() as AbilityUpgrade
		chosen_upgrades.append(chosen_upgrade)
		upgrades.erase(chosen_upgrade)
	return chosen_upgrades
	
	
func handle_skill_selected(upgrade: AbilityUpgrade):
	if upgrade.skill:
		upgrade_pool.erase(upgrade)


func check_is_max_lvl(upgrade: AbilityUpgrade): 
	if current_upgrades[upgrade.id]["lvl"] >= 15:
		upgrade_pool.erase(upgrade)
	
	
func apply_upgrade(upgrade: AbilityUpgrade):
	var has_upgrade = current_upgrades.has(upgrade.id)
	handle_skill_selected(upgrade)
	if !has_upgrade:
		current_upgrades[upgrade.id] = {
			"resource" : upgrade,
			"lvl": 1
		}
	else:
		current_upgrades[upgrade.id]["lvl"] += 1
		check_is_max_lvl(upgrade) 
	GameEvents.emit_ability_upgrade_added(upgrade, current_upgrades)


func handle_abiliti_selected(upgrade: AbilityUpgrade):
	apply_upgrade(upgrade)


func call_ability_upgrade_action():
	var picked_upgrades = pick_upgrades()
	if picked_upgrades.size() > 0:
		var upgrade_screen_instance = upgrade_sreene_scene.instantiate()
		add_child(upgrade_screen_instance)
		upgrade_screen_instance.set_ability_upgrades(picked_upgrades)
		upgrade_screen_instance.ability_upgrade_selected.connect(handle_abiliti_selected)
	else:
		print("TODO screen with money")