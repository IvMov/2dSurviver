extends CharacterBody2D

@onready var velocity_component = $VelocityComponent
@onready var animation_player = $AnimationPlayer
@onready var timer = $Timer
@onready var health_component = $HealthComponent
@onready var enemy_drop_component = $EnemyDropComponent
@onready var hurtbox_component = $HurtboxComponent
@onready var life_time_timer = $LifeTimeTimer
@onready var random_audio_player_2d_component = $RandomAudioPlayer2DComponent
@onready var collision_timer = $CollisionTimer


var is_boss: bool = false
var hurt: int = 1
var base_speed: int
var is_collided: bool

func _ready():
	base_speed = velocity_component.max_speed
	hurtbox_component.hit.connect(on_hit)
	collision_timer.timeout.connect(on_collision_timer_timeout)
	
func _process(delta):
	velocity_component.move(self)
	if !is_boss:
		velocity_component.max_speed = base_speed + int((999-life_time_timer.time_left)/2)
	if is_boss:
		calc_collides()

func collided():
	is_collided = true
	collision_timer.start()

func _on_timer_timeout():
	if is_collided:
		return
	velocity_component.accelerate_to_player(self)
	

func calc_collides():
	var collision = get_last_slide_collision()
	if collision:
		var collider = collision.get_collider();
		if collider.is_in_group("enemy"):
			collider.velocity = (velocity).rotated(randf_range(-1, 1))*1.5;
			collider.collided()


func on_hit():
	random_audio_player_2d_component.play_random_stream()
	
	
func on_collision_timer_timeout():
	is_collided = false
	velocity_component.accelerate_to_player(self)
