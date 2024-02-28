extends Node

@export var max_speed: int = 40
@export var acceleration: float = 5
@export var navigation: NavigationAgent2D;
@onready var player = get_tree().get_root().get_node("Main").get_node("Entities").get_node("Player")


func set_player_position():
	if !player:
		return
	navigation.set_target_position(player.global_position)
	
func _on_timer_timeout():
	set_player_position()
