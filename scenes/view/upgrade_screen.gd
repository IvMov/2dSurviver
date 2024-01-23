extends CanvasLayer

signal ability_upgrade_selected(upgrade: AbilityUpgrade)

@export var upgrade_card_scene: PackedScene
@onready var card_container: HBoxContainer = %CardContainer

func _ready():
	get_tree().paused = true

func set_ability_upgrades(upgrades: Array[AbilityUpgrade]):
	for upgrade in upgrades:
		var card_instance = upgrade_card_scene.instantiate()
		card_container.add_child(card_instance)
		card_instance.set_ability_upgrade(upgrade)
		card_instance.card_selected.connect(on_selected_do.bind(upgrade))

func on_selected_do(upgrade: AbilityUpgrade):
	ability_upgrade_selected.emit(upgrade)
