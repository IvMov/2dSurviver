extends Node

@export var axe_ability_scene: PackedScene
@export var upgrades: Array[AbilityUpgrade]
@onready var ability_timer = %AbilityTimer
@onready var audio_stream_player = $AudioStreamPlayer

var controller_name = "Axe"
var damage = 7
var base_wait_time: float

func _ready():
	ability_timer.timeout.connect(on_timer_timeout)
	ability_timer.wait_time = 1.6
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
	audio_stream_player.play()
	var axe_instance = axe_ability_scene.instantiate() as Node2D
	foreground.add_child(axe_instance)
	axe_instance.global_position = player.global_position
	axe_instance.hitbox_component.damage = damage
	


func rescale_audio():
	if ability_timer.wait_time < .6:
		audio_stream_player.pitch_scale = 1.2
	elif ability_timer.wait_time < 1:
		audio_stream_player.pitch_scale = 1
	else: 
		audio_stream_player.pitch_scale = 0.8

func on_ability_upgrad_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	if upgrade.id == "axe_rate":
		var percent_improve = current_upgrades["axe_rate"]["lvl"] * upgrade.amount
		ability_timer.wait_time = max(base_wait_time - percent_improve, 0.2)
		ability_timer.start()
		rescale_audio()
		GameEvents.emit_ability_upgrade_applied()
	elif upgrade.id == "axe_dmg":
		damage *= 1 + upgrade.amount
		GameEvents.emit_ability_upgrade_applied()

