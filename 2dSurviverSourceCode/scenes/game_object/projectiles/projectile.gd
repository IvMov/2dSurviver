extends Area2D
class_name Projectile

@export var speed: int
@export var direction: Vector2
@onready var life_timer = $LifeTimer
	
func _ready():
	body_entered.connect(on_body_entered)
	area_entered.connect(on_area_entered)
	life_timer.timeout.connect(on_life_timer_timeout)

func _physics_process(delta):
	translate(direction * speed * delta)


func on_body_entered(body):
	if body is Player:
		body.check_deal_damage(true)
	queue_free()
	
	
func on_area_entered(other_area: Area2D):
	if other_area is HitboxComponent:
		queue_free()


func on_life_timer_timeout():
	queue_free()
