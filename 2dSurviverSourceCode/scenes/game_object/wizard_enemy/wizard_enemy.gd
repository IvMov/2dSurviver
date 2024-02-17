extends CharacterBody2D

@onready var velocity_component = $VelocityComponent
@onready var sprites = $Sprites


func _process(delta):
	velocity_component.accelerate_to_player()
	velocity_component.move(self)
	
	var direction: Vector2 = Vector2(-1, 1) if sign(velocity.x) < 0 else Vector2.ONE
	sprites.set_scale(direction)
	
