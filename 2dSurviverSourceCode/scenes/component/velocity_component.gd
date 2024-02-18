extends Node

@export var max_speed: int = 40
@export var acceleration: float = 5

var velocity = Vector2.ZERO

func accelerate_to_player():
	var owner_node = owner as Node2D
	if !owner_node:
		return
	
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if !player:
		return
	
	var direction = (player.global_position - owner_node.global_position).normalized()
	accelerate_in_dirrection(direction)

func accelerate_in_dirrection(direction: Vector2):
	var desired_velocity = direction * max_speed
	velocity = velocity.lerp(desired_velocity, 1 - exp(-acceleration * get_process_delta_time())) 
	

func move(character_body: CharacterBody2D):
	character_body.velocity = velocity
	character_body.move_and_slide()
	velocity = character_body.velocity
