extends Node
class_name UpgradeManager

@export var upgrade_pool: Array[AbilityUpgrade]
@export var upgrade_pool_core: Array[AbilityUpgrade]
@export var self_abilities: AbilityUpgrade
@export var upgrade_sreene_scene: PackedScene

var current_upgrades = {
}

func _ready():
	upgrade_pool = upgrade_pool_core.duplicate()
	GameEvents.call_abillity_upgrade.connect(call_ability_upgrade_action)
	call_first_abillity()
	if !upgrade_pool.has(self_abilities):
		upgrade_pool.append(self_abilities)	
	


func pick_upgrades(core_upgrades: Array[AbilityUpgrade], count: int) :
	if core_upgrades.is_empty():
		return []
	var upgrades = core_upgrades.duplicate()
	var chosen_upgrades: Array[AbilityUpgrade] = []
	for i in count:
		if upgrades.is_empty():
			return chosen_upgrades
		var chosen_upgrade = upgrades.pick_random() as AbilityUpgrade
		if chosen_upgrade:
			chosen_upgrades.append(chosen_upgrade)
			upgrades.erase(chosen_upgrade)
	return chosen_upgrades


func pick_abilities() :
	var upgrades = upgrade_pool.duplicate() as Array[AbilityUpgrade]
	var chosen_upgrades: Array[AbilityUpgrade] = []
	for upgrade in upgrades:
		if (upgrade.skill):
			chosen_upgrades.append(upgrade)
	return pick_upgrades(chosen_upgrades, 3);	
	
	
func handle_skill_selected(upgrade: AbilityUpgrade):
	if upgrade.skill:
		upgrade_pool.erase(upgrade)


func check_is_max_lvl(upgrade: AbilityUpgrade): 
	if current_upgrades[upgrade.id]["lvl"] >= upgrade.max_lvl:
		upgrade_pool.erase(upgrade)
	
func get_upgrade_level(upgrade: AbilityUpgrade) -> int:
	return 0 if !current_upgrades.has(upgrade.id) else current_upgrades[upgrade.id]["lvl"]
	
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
	var picked_upgrades = pick_upgrades(upgrade_pool, 3)
	if picked_upgrades.size() > 0:
		var upgrade_screen_instance = upgrade_sreene_scene.instantiate()
		add_child(upgrade_screen_instance)
		upgrade_screen_instance.set_ability_upgrades(picked_upgrades)
		upgrade_screen_instance.ability_upgrade_selected.connect(handle_abiliti_selected)
	else:
		print("TODO screen with money")


func call_first_abillity():
	var abilities = pick_abilities();
	if abilities.size() > 0:
		var upgrade_screen_instance = upgrade_sreene_scene.instantiate()
		add_child(upgrade_screen_instance)
		upgrade_screen_instance.set_ability_upgrades(abilities)
		upgrade_screen_instance.ability_upgrade_selected.connect(handle_abiliti_selected)
	
	
