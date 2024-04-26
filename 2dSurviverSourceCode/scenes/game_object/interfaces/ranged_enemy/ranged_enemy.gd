extends BasicEnemy
class_name RangedEnemy


@onready var stand_timer = $StandTimer
@onready var attack_cd_timer = $AttackCdTimer

@export var projectile_scene: PackedScene

@export var shoot_cd: float = 0.5
@export var projectile_speed: int = 100
@export var attack_distance: int = 110

func _ready():
	super._ready()
	if is_boss:
		attack_distance = 200
	attack_cd_timer.wait_time = shoot_cd
	stand_timer.timeout.connect(on_attack_timer_timeout)
	

func _process(delta):
	if stand_timer.is_stopped() && global_position.distance_to(velocity_component.get_player_position()) <= attack_distance:
		is_moving = false
		stand_timer.start()
	if !stand_timer.is_stopped() && attack_cd_timer.is_stopped():
		shoot()
		attack_cd_timer.start()
	super._process(delta)

func collided():
	is_moving = true
	super.collided()

func on_attack_timer_timeout():
	is_moving = true


func shoot():
	var projectile: Projectile = projectile_scene.instantiate() 
	get_tree().get_first_node_in_group("projectiles_layer").add_child(projectile)
	projectile.global_position = global_position
	projectile.global_position.y-=7
	projectile.speed  = projectile_speed
	if is_boss:
		projectile.set_scale(Vector2(3,3))
		projectile.speed = int(projectile.speed * 1.5)
		attack_cd_timer.wait_time = 0.2
		projectile.global_position.y-=7*4
	projectile.direction = (velocity_component.get_player_position() - projectile.global_position).normalized()
	projectile.rotate(projectile.direction.angle())
