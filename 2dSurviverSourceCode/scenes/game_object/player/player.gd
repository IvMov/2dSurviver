extends CharacterBody2D
class_name Player

@export var floating_text: PackedScene
@onready var damage_interval_timer = $DamageIntervalTimer
@onready var health_component = $HealthComponent as HealthComponent
@onready var animation = $AnimationPlayer
@onready var sprites = $Sprites
@onready var skill_timer = %SkillTimer
@onready var skill_bar = %SkillBar
@onready var velocity_component = $VelocityComponent

var number_colliding_bodies: int = 0
var hurt:int = 1

func _ready():
	$CollisionArea2D.body_entered.connect(on_body_entered)
	$CollisionArea2D.body_exited.connect(on_body_exited)
	GameEvents.new_level.connect(on_new_lvl)
	damage_interval_timer.timeout.connect(on_damage_interval_timeout_timeout)
	skill_bar.max_value = skill_timer.wait_time

func _input(event):
	if event.is_action_pressed("active_skill") && skill_timer.is_stopped():
		var movement_vector = get_movement_vector()
		var direction = movement_vector.normalized()
		var target_velocity = direction * 30000
		velocity  = velocity.lerp(target_velocity, 1 - exp(-.3))
		velocity_component.move(self)
		skill_timer.start()


func _process(delta):
	var movement_vector = get_movement_vector()
	
	var direction = movement_vector.normalized()
	var target_velocity = direction * velocity_component.max_speed
	velocity_component.accelerate_in_dirrection(self, direction)
	velocity  = velocity.lerp(target_velocity, 1 - exp(-delta * velocity_component.acceleration))
	animate_player(movement_vector)
	velocity_component.move(self)
	skill_bar.value = skill_timer.time_left
	var collision = get_last_slide_collision()
	if collision:
		var collider = collision.get_collider();
		if collider.is_in_group("enemy"):
			if(velocity.length() > 300):
				collider.velocity = (velocity/2).rotated(randf_range(-1, 1))
			else:	
				collider.velocity = velocity.rotated(randf_range(-1, 1))*1.5;
			collider.move_and_slide()


func get_movement_vector():
	var x_movement = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var y_movement = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	var vector = Vector2(x_movement, y_movement)
	
	return vector


func check_deal_damage():
	if number_colliding_bodies == 0 || !damage_interval_timer.is_stopped():
		return
	GameEvents.emit_player_damaged(hurt)
	var floating_text_inst = floating_text.instantiate() as Node2D
	health_component.damage(hurt)
	damage_interval_timer.start()
	floating_text.instantiate()
	
	get_parent().add_child(floating_text_inst)
	floating_text_inst.label.set_modulate(Color.RED)
	floating_text_inst.global_position = global_position;
	floating_text_inst.z_index = 1;
	floating_text_inst.start(hurt)

func animate_player(movement_vector: Vector2):
	var animation_name = "RESET" if movement_vector.is_zero_approx() else "walk"
	animation.play(animation_name)
	var playerdirection: Vector2 = Vector2(-1, 1) if sign(movement_vector.x) < 0 else Vector2.ONE
	sprites.set_scale(playerdirection)
	
	
func on_body_entered(body: Node2D):
	number_colliding_bodies += 1
	if PlayerCounters.current_level < 40:
		hurt = 10 if body.is_boss else 1
	else:
		hurt = 20 if body.is_boss else 3
	check_deal_damage()


func on_body_exited(body: Node2D):
	number_colliding_bodies -= 1


func on_damage_interval_timeout_timeout():
	check_deal_damage()
	
func on_new_lvl(lvl: int):
	health_component.max_health += 2
	health_component.current_health = min(health_component.max_health, health_component.current_health+3)
	
	
