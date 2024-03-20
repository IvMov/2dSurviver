extends CanvasLayer

signal ability_upgrade_selected(upgrade: AbilityUpgrade)

@export var upgrade_card_scene: PackedScene
@onready var card_container: HBoxContainer = %CardContainer
@onready var animation_player: AnimationPlayer = %AnimationPlayer

var disable_inputs: bool = false

func _ready():
	get_tree().paused = true


func set_ability_upgrades(upgrades: Array[AbilityUpgrade]):
	for upgrade in upgrades:
		var card_instance = upgrade_card_scene.instantiate()
		card_container.add_child(card_instance)
		card_instance.set_ability_upgrade(upgrade)
		card_instance.card_selected.connect(on_selected_do.bind(upgrade))
		await card_instance.animation_player.animation_finished


func clean_cards_from_screen():
	await get_tree().create_timer(0.2).timeout
	var cards = card_container.get_children()
	for card in cards:
		if !card:
			return
		card.play_unselected()	
		await card.tween.finished
		card.queue_free()


func on_selected_do(upgrade: AbilityUpgrade):
	ability_upgrade_selected.emit(upgrade)
	clean_cards_from_screen()
	animation_player.play("out")
	await  animation_player.animation_finished
	get_tree().paused = false
	queue_free()
