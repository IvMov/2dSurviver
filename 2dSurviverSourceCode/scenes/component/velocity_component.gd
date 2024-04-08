extends Node

@export var max_speed: int = 90
@export var acceleration: float = 5
@onready var player = get_tree().get_root().get_node("Main").get_node("Entities").get_node("Player")
@onready var enemy_manager = get_tree().get_first_node_in_group("enemy_manager")


var velocity = Vector2.ZERO

func accelerate_to_player(character_body: CharacterBody2D):
	if !player:
		return
	if character_body.global_position.distance_to(player.global_position) > (enemy_manager.SPAWN_RADIUS+100):
		character_body.global_position = enemy_manager.get_spawn_position(player.global_position, enemy_manager.SPAWN_RADIUS)
	var direction = (player.global_position - character_body.global_position).normalized()
	accelerate_in_dirrection(character_body, direction)


func accelerate_in_dirrection(character_body: CharacterBody2D, direction: Vector2):
	var desired_velocity = direction * max_speed
	velocity = velocity.lerp(desired_velocity, exp(-get_process_delta_time()*acceleration)) 
	character_body.velocity = velocity


func move(character_body: CharacterBody2D):
	character_body.move_and_slide()


