extends CharacterBody2D
class_name Player

@export var hp_up: MetaUpgrade
@export var hp_regen: MetaUpgrade
@export var floating_text: PackedScene
@onready var damage_interval_timer = $DamageIntervalTimer
@onready var health_component = $HealthComponent as HealthComponent
@onready var animation = $AnimationPlayer
@onready var sprites = $Sprites
@onready var skill_timer = %SkillTimer
@onready var skill_bar = %SkillBar
@onready var velocity_component: VelocityComponent = $VelocityComponent
@onready var skill_audio_player = $SkillAudioPlayer
@onready var collision_audio_player = $CollisionAudioPlayer
@onready var collision_shape_2d = $PickupArea/CollisionShape2D
@onready var hp_regen_timer = $HpRegenTimer


var number_colliding_bodies: int = 0
var hurt:int = 1
var last_direction: Vector2
var dodge_speed = 800
var hp_regen_value: float
var current_dodge_speed = dodge_speed
var start_hp: float
var last_collider


func _ready():
	hp_regen_value = calculate_hp_regen()
	$CollisionArea2D.body_entered.connect(on_body_entered)
	$CollisionArea2D.body_exited.connect(on_body_exited)
	GameEvents.new_level.connect(on_new_lvl)
	collision_shape_2d.shape.radius = 15
	damage_interval_timer.timeout.connect(on_damage_interval_timeout_timeout)
	skill_bar.max_value = skill_timer.wait_time
	hp_regen_timer.timeout.connect(on_hp_regen_timer_timeout)
	health_component.health_changed.connect(on_health_changed)
	start_hp = calulate_start_hp()
	health_component.max_health = start_hp
	health_component.current_health = start_hp
	health_component.health_changed.emit(false)	
	set_collision_layer(2)


func _input(event):
	if event.is_action_pressed("active_skill") && skill_timer.is_stopped():
		var movement_vector = get_movement_vector()
		if movement_vector == Vector2.ZERO:
			movement_vector = (Vector2.ONE).rotated(randf_range(0, TAU))
		last_direction = movement_vector.normalized()
		current_dodge_speed = dodge_speed
		var target_velocity = last_direction * current_dodge_speed
		velocity  = target_velocity.lerp(target_velocity, exp(-get_process_delta_time()*velocity_component.acceleration))
		skill_audio_player.play()
		velocity_component.move(self)
		skill_timer.start()


func _process(delta):
	skill_bar.value = skill_timer.time_left
	handle_collision(delta)
	if skill_timer.time_left > 0 && (1.5 - skill_timer.time_left <= 0.3):
		velocity_component.move(self)
	else:
		move_player(delta)


func move_player(delta):
	var movement_vector = get_movement_vector()
	var direction = movement_vector.normalized()
	var target_velocity = direction * velocity_component.max_speed
	velocity_component.accelerate_in_dirrection(self, direction)
	velocity  = velocity.lerp(target_velocity, (1-exp(-delta * velocity_component.acceleration)))
	velocity_component.move(self)
	animate_player(movement_vector)
	

func handle_collision(delta):
	var collision = get_last_slide_collision()
	if collision:
		var collider = collision.get_collider();
		if collider && last_collider == collider && collider.is_in_group("enemy"):
			return
		last_collider = collider
		if collider && collider.is_in_group("enemy"):
			if !skill_timer.is_stopped() && (1.5 - skill_timer.time_left <= 0.3):
				collider.velocity = (velocity/2).rotated(randf_range(-1.5, 1.5))
				collider.collided()
				collider.hurtbox_component.get_damaged(5)
				current_dodge_speed-=50
				velocity = velocity.lerp(last_direction * current_dodge_speed, exp(-delta*velocity_component.acceleration))
				collision_audio_player.play()
			else:	
				collider.velocity = velocity.rotated(randf_range(-1.5, 1.5))*1.5;
				collider.collided()
	

func get_movement_vector():
	var x_movement = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var y_movement = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	var vector = Vector2(x_movement, y_movement)
	
	return vector


func check_deal_damage(is_distance_damage: bool):
	if number_colliding_bodies == 0 || !damage_interval_timer.is_stopped():
		if is_distance_damage:
			hurt = 1
			deal_damage()
		return
	deal_damage()
	

func deal_damage():
	GameEvents.emit_player_damaged(hurt)
	var floating_text_inst = floating_text.instantiate() as Node2D
	health_component.damage(hurt)
	damage_interval_timer.start()
	floating_text.instantiate()
	
	get_parent().add_child(floating_text_inst)
	floating_text_inst.global_position = global_position;
	floating_text_inst.z_index = 1;
	floating_text_inst.start(hurt)
	floating_text_inst.label.set_modulate(Color.RED)
	
	

func animate_player(movement_vector: Vector2):
	var animation_name = "RESET" if movement_vector.is_zero_approx() else "walk"
	animation.play(animation_name)
	var playerdirection: Vector2 = Vector2(-1, 1) if sign(movement_vector.x) < 0 else Vector2.ONE
	sprites.set_scale(playerdirection)

func calulate_start_hp():
	var current_lvl = MetaProgression.meta_data["upgrades"][hp_up.id]["lvl"]
	return hp_up.base + (hp_up.value * current_lvl);
	


func calculate_hp_regen():
	var current_lvl = MetaProgression.meta_data["upgrades"][hp_regen.id]["lvl"]
	var regen_val = hp_regen.base + (hp_regen.value * current_lvl);
	if regen_val > 0.0:
		hp_regen_timer.start()
		
	return regen_val
	
	
func on_body_entered(body: Node2D):
	number_colliding_bodies += 1
	if PlayerCounters.current_level < 40:
		hurt = 10 if body.is_boss else body.hurt
	else:
		hurt = 15 if body.is_boss else (body.hurt * 2)
	check_deal_damage(false)


func on_body_exited(body: Node2D):
	number_colliding_bodies -= 1


func on_damage_interval_timeout_timeout():
	check_deal_damage(false)
	
func on_new_lvl(lvl: int):
	var odd = PlayerCounters.current_level%2
	health_component.max_health+=(odd * 3)
	velocity_component.max_speed = min(velocity_component.max_speed + odd, 250)
	var heal_mount: float = health_component.max_health/10
	health_component.current_health = min(health_component.max_health, health_component.current_health+heal_mount)
	health_component.health_changed.emit(false)


func on_hp_regen_timer_timeout():
	if health_component.max_health == health_component.current_health:
		hp_regen_timer.stop()
		return
	health_component.current_health = min(health_component.max_health, health_component.current_health+hp_regen_value)
	health_component.health_changed.emit(false)
	

func on_health_changed(is_hurt: bool):
	if health_component.max_health != health_component.current_health && hp_regen_value > 0.0:
		hp_regen_timer.start()
	
