extends CharacterBody2D

@onready var navigation_agent_2d = $NavigationAgent2D as NavigationAgent2D
@onready var velocity_component = $VelocityComponent
@onready var animation_player = $AnimationPlayer

func _ready():
	velocity_component.set_player_position()
	
func _process(delta):
	var next_path_pos = navigation_agent_2d.get_next_path_position()
	var dir = global_position.direction_to(next_path_pos)
	var desired_velocity = dir * velocity_component.max_speed
	velocity = velocity.lerp(desired_velocity, 1 - exp(-velocity_component.acceleration * delta))

	move_and_slide()

func walk():
	animation_player.play("walk")
