extends CharacterBody2D

@onready var velocity_component = $VelocityComponent
@onready var sprites = $Sprites
@onready var navigation_agent_2d = $NavigationAgent2D
@onready var animation_player = $AnimationPlayer


var is_moving: bool = true

func _ready():
	velocity_component.set_player_position()
	

func _process(delta):
	
	var next_path_pos = navigation_agent_2d.get_next_path_position()
	var dir = global_position.direction_to(next_path_pos)
	var desired_velocity = dir * velocity_component.max_speed
	if is_moving:
		velocity = velocity.lerp(desired_velocity, 1 - exp(-velocity_component.acceleration * delta))
	else: 
		velocity = velocity.lerp(Vector2.ZERO, 1 - exp(-velocity_component.acceleration * delta)) # stops for a while 
	move_and_slide()
	#used in animation
	var direction_look: Vector2 = Vector2(-1, 1) if sign(velocity.x) < 0 else Vector2.ONE
	sprites.set_scale(direction_look)
	
	
#used in animation
func set_is_moving(moving: bool): 
	is_moving = moving

func move():
	animation_player.play("move")

