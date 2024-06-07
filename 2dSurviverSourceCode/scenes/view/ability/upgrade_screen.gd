extends CanvasLayer

signal ability_upgrade_selected(upgrade: AbilityUpgrade)

@export var upgrade_card_scene: PackedScene
@onready var card_container: HBoxContainer = %CardContainer
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var audio_stream_player = $AudioStreamPlayer
var upgrade_manager: UpgradeManager
@onready var label = $MarginContainer/Label
@onready var timer = $Timer

var disable_inputs: bool = false
var skill_inputs: Array = [1, 2, 3]

func _ready():
	disable_inputs = true
	if PlayerCounters.current_level  > 0:
		label.text = "! NEW LEVEL - %d !" % PlayerCounters.current_level 
	get_tree().paused = true
	audio_stream_player.play()
	upgrade_manager = get_tree().get_first_node_in_group("upgrade_manager")
	timer.timeout.connect(on_timer_timeout)


func _input(event):
	if disable_inputs:
		return
	var event_value : String = event.as_text();
	if event_value.length() > 1:
		return
		
	if event_value.is_valid_int():
		var card_num = int(event_value) - 1 
		var cards = card_container.get_children()
		if cards.is_empty() || cards.size() <= card_num:
			return
		var card = cards[card_num]
		card.select_card()
		


func set_ability_upgrades(upgrades: Array[AbilityUpgrade]):
	var i = 1;
	for upgrade in upgrades:
		
		if !upgrade:
			return
		var card_instance: AbilityCard = upgrade_card_scene.instantiate()
		card_instance.current_ability_lvl = upgrade_manager.get_upgrade_level(upgrade)
		card_container.add_child(card_instance)
		card_instance.hotkey_label.text = " press %d" % i
		card_instance.set_ability_upgrade(upgrade)
		
		card_instance.card_selected.connect(on_selected_do.bind(upgrade))
		await card_instance.animation_player.animation_finished
		i+=1;


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
	queue_free()

func on_timer_timeout():
	disable_inputs = false
	card_container.set_mouse_filter(Control.MOUSE_FILTER_PASS)
