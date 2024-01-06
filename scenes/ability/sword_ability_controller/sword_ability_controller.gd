extends Node

@export var sword_ability: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.timeout.connect(action_on_timer_timeout)

func action_on_timer_timeout():
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if !player:
		return
	
	var sword_ability = sword_ability.instantiate() as Node2D	
	player.get_parent().add_child(sword_ability)
	sword_ability.global_position = player.global_position
