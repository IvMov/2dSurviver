extends HitboxComponent
class_name PlayerProjectile

@export var speed: int
@export var direction: Vector2
@onready var life_timer = $LifeTimer
var life_time: float	
	
func _ready():
	life_timer.wait_time = life_time
	life_timer.start()
	life_timer.timeout.connect(on_life_timer_timeout)

func _physics_process(delta):
	translate(direction * speed * delta)


func on_life_timer_timeout():
	queue_free()
