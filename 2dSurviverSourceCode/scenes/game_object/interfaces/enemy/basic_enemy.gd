extends CharacterBody2D
class_name BasicEnemy

@export var animation_player: AnimationPlayer
@onready var health_component = $HealthComponent
@onready var enemy_drop_component = $EnemyDropComponent
@onready var hurtbox_component = $HurtboxComponent
@onready var velocity_component: VelocityComponent = $VelocityComponent
@onready var sprites = $Sprites

@onready var life_time_timer = $LifeTimeTimer
@onready var random_audio_player_2d_component = $RandomAudioPlayer2DComponent
@onready var collision_timer = $CollisionTimer


var is_boss: bool = false
var hurt: int = 2 if PlayerCounters.game_difficulty > 2 else 1
var base_speed: int
var is_collided: bool
var is_moving: bool = true


func _ready():
	base_speed = velocity_component.max_speed
	health_component.health_bar.modulate = Color(1, 0.616, 1)
	hurtbox_component.hit.connect(on_hit)
	collision_timer.timeout.connect(on_collision_timer_timeout)
	
	
func _process(delta):
	if is_moving:
		velocity_component.move(self)
	if !is_boss:
		velocity_component.max_speed = base_speed + int((999-life_time_timer.time_left)/2)
	if is_boss:
		calc_collides()
	animate_enemy()
	

func animate_enemy():
	var animation_name = "RESET" if !is_moving else "walk"
	animation_player.play(animation_name)
	var direction_look: Vector2 = Vector2(-1, 1) if sign(velocity.x) < 0 else Vector2.ONE
	sprites.set_scale(direction_look)

func collided():
	is_collided = true
	collision_timer.start()
	
	
func calc_collides():
	var collision = get_last_slide_collision()
	if collision:
		var collider = collision.get_collider();
		if collider && collider.is_in_group("enemy") && !collider.is_boss:
			collider.velocity = (velocity).rotated(randf_range(-1, 1))*2;
			collider.collided()


func _on_timer_timeout():
	if is_collided:
		return
	velocity_component.accelerate_to_player(self)
	

func set_is_boss(coins_base: int, exp_base: int):
	set_scale(Vector2(5,5))
	var current_lvl = PlayerCounters.current_level
	
	#stats
	velocity_component.max_speed = 100 + current_lvl
	health_component.max_health = 100 + (current_lvl * 20)
	if	current_lvl > 50:
		health_component.max_health = 100 + (current_lvl * 40)
	health_component.current_health = health_component.max_health
	health_component.update_health_bar()
	
	#drop
	enemy_drop_component.COINS_BASE = coins_base + current_lvl
	enemy_drop_component.basic_exp_drop = exp_base + current_lvl
	enemy_drop_component.coin_drop_chance = 1
	enemy_drop_component.calc_coins_and_exp()

	is_boss = true
	


func on_hit():
	random_audio_player_2d_component.play_random_stream()
	
	
func on_collision_timer_timeout():
	is_collided = false
	velocity_component.accelerate_to_player(self)
