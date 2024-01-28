extends Node

@export var end_screen: PackedScene
@onready var timer = $Timer


func _ready():
	timer.timeout.connect(on_timer_timeout)


func get_time_elapsed():
	return timer.wait_time - timer.time_left


func on_timer_timeout():
	var end_screen_instance = end_screen.instantiate()
	get_parent().add_child(end_screen_instance)

	
