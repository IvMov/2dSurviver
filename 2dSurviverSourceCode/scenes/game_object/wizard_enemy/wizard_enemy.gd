extends CharacterBody2D

@onready var velocity_component = $VelocityComponent
@onready var sprites = $Sprites

var is_moving: bool = true


func _process(delta):
	
	if is_moving:
		velocity_component.accelerate_to_player()
	else: 
		velocity_component.accelerate_in_dirrection(Vector2.ZERO) # stops for a while 
		
	velocity_component.move(self)
	
	var direction: Vector2 = Vector2(-1, 1) if sign(velocity.x) < 0 else Vector2.ONE
	sprites.set_scale(direction)
	
	
func set_is_moving(moving: bool):
	is_moving = moving
