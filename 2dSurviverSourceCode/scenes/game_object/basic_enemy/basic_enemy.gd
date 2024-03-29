extends CharacterBody2D

@onready var velocity_component = $VelocityComponent
@onready var animation_player = $AnimationPlayer
@onready var timer = $Timer
@onready var health_component = $HealthComponent
@onready var enemy_drop_component = $EnemyDropComponent

var is_boss: bool = false
var hurt: int = 1

func _process(delta):
	velocity_component.move(self)
	if is_boss:
		calc_collides()



func _on_timer_timeout():
	velocity_component.accelerate_to_player(self)

func calc_collides():
	var collision = get_last_slide_collision()
	if collision:
		var collider = collision.get_collider();
		if collider.is_in_group("enemy"):
			collider.velocity = (velocity).rotated(randf_range(-1, 1))*1.5;
			collider.move_and_slide()
