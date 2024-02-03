extends CharacterBody2D
class_name Player

const SPEED: float = 130
const ACCELERATION_SMOOTHING = 10
@onready var damage_interval_timer = $DamageIntervalTimer
@onready var health_component = $HealthComponent
@onready var health_bar = $HealthBar
@onready var animation = $AnimationPlayer
@onready var sprites = $Sprites

var current_speed: float = SPEED
var number_colliding_bodies: int = 0

func _ready():
	$CollisionArea2D.body_entered.connect(on_body_entered)
	$CollisionArea2D.body_exited.connect(on_body_exited)
	damage_interval_timer.timeout.connect(on_damage_interval_timeout_timeout)
	health_component.max_health = 15
	health_component.current_health = health_component.max_health
	health_component.health_changed.connect(on_health_changed)
	GameEvents.ability_upgrade_added.connect(on_ability_upgrad_added)
	update_health_bar()


func _process(delta):
	var movement_vector = get_movement_vector()
	var direction = movement_vector.normalized()
	var target_velocity = direction * current_speed
	velocity  = velocity.lerp(target_velocity, 1 - exp(-delta * ACCELERATION_SMOOTHING))
	animate_player(movement_vector)
	move_and_slide()

func get_movement_vector():
	var x_movement = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var y_movement = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	
	return Vector2(x_movement, y_movement)


func check_deal_damage():
	if number_colliding_bodies == 0 || !damage_interval_timer.is_stopped():
		return
	health_component.damage(1)
	damage_interval_timer.start()


func update_health_bar():
	health_bar.value = health_component.get_health_precent()	


func animate_player(movement_vector: Vector2):
	var animation_name = "calm" if movement_vector.is_zero_approx() else "walk"
	animation.play(animation_name)
	var playerdirection: Vector2 = Vector2(-1, 1) if sign(movement_vector.x) < 0 else Vector2.ONE
	sprites.set_scale(playerdirection)
	
	
func on_body_entered(body: Node2D):
	number_colliding_bodies += 1
	check_deal_damage()


func on_body_exited(body: Node2D):
	number_colliding_bodies -= 1


func on_damage_interval_timeout_timeout():
	check_deal_damage()
	
	
func on_health_changed():
	update_health_bar()
	
func on_ability_upgrad_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	if upgrade.id == "movement_speed":
		current_speed = SPEED + (current_upgrades["movement_speed"]["lvl"] * (SPEED*3 /100))
