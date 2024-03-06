extends Node

@export var axe_ability_scene: PackedScene
@export var upgrades: Array[AbilityUpgrade]
@onready var ability_timer = %AbilityTimer

var controller_name = "Axe"
var damage = 7
var base_wait_time: float

func _ready():
	ability_timer.timeout.connect(on_timer_timeout)
	ability_timer.wait_time = 2
	ability_timer.start()
	base_wait_time = ability_timer.wait_time
	GameEvents.ability_upgrade_added.connect(on_ability_upgrad_added)
	

func on_timer_timeout():
	var player = get_tree().get_first_node_in_group("player") as Player
	if !player: 
		return
	
	var foreground = get_tree().get_first_node_in_group("foreground_layer")
	if !foreground:
		return
	
	var axe_instance = axe_ability_scene.instantiate() as Node2D
	foreground.add_child(axe_instance)
	axe_instance.global_position = player.global_position
	axe_instance.hitbox_component.damage = damage


func on_ability_upgrad_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	if upgrade.id == "axe_rate":
		var percent_improve = current_upgrades["axe_rate"]["lvl"] * .05
		ability_timer.wait_time = max(base_wait_time * (1 - percent_improve), 0.01)
		ability_timer.start()
	if upgrade.id == "axe_dmg":
		var percent_improve = current_upgrades["axe_dmg"]["lvl"] * .05
		damage += damage * percent_improve

