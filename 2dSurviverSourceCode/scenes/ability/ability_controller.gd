extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	GameEvents.ability_upgrade_added.connect(on_ability_upgrad_added)


func on_ability_upgrad_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	if upgrade is Ability:
		var instance = upgrade.ability_controller.instantiate();
		get_parent().add_child(instance)
		var upgrade_manger = get_tree().get_first_node_in_group("upgrade_manager") as UpgradeManager
		upgrade_manger.upgrade_pool.append_array(instance.upgrades)

