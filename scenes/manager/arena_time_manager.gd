extends Node

signal arena_difficulty_increased(arena_difficulty: int)

const DIFFICULTY_INTERVAL = 10

@export var end_screen: PackedScene
@onready var timer = $Timer

var arena_dificulty = 0

func _ready():
	timer.timeout.connect(on_timer_timeout)


func _process(delta):
	var next_time_target = timer.wait_time - ((arena_dificulty+1) * DIFFICULTY_INTERVAL)
	if timer.time_left <= next_time_target:
		arena_dificulty += 1
		arena_difficulty_increased.emit(arena_dificulty)

func get_time_elapsed():
	return timer.wait_time - timer.time_left


func on_timer_timeout():
	var end_screen_instance = end_screen.instantiate()
	get_parent().add_child(end_screen_instance)

	
