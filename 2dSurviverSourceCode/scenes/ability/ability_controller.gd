extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	GameEvents.ability_upgrade_added.connect(on_ability_upgrad_added)


func on_ability_upgrad_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	if upgrade is Ability:
		get_parent().add_child(upgrade.ability_controller.instantiate())

