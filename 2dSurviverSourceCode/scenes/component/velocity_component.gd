extends Node

@export var max_speed: int = 40
@export var acceleration: float = 5
@onready var player = get_tree().get_root().get_node("Main").get_node("Entities").get_node("Player")


var velocity = Vector2.ZERO

func accelerate_to_player(character_body: CharacterBody2D):
	var direction = (player.global_position - character_body.global_position).normalized()
	accelerate_in_dirrection(character_body, direction)


func accelerate_in_dirrection(character_body: CharacterBody2D, direction: Vector2):
	var desired_velocity = direction * max_speed
	velocity = velocity.lerp(desired_velocity, 1 - exp(-acceleration * .5)) 
	character_body.velocity = velocity


func move(character_body: CharacterBody2D):
	character_body.move_and_slide()


