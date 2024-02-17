extends Node
class_name HealthComponent

signal died
signal health_changed

@export var health_bar: Node
@export var max_health: float
var current_health: float


func _ready():
	max_health = max_health + (randf() * 5)
	current_health = max_health
	health_changed.connect(on_health_changed)
	update_health_bar()
	
	
func damage(amount: float):
	current_health = max(current_health - amount, 0)
	health_changed.emit()
	Callable(check_death).call_deferred()


func check_death():
	if current_health == 0:
		died.emit()
		EnemyCounter.minus_enemy()
		owner.queue_free()
	
		
func get_health_precent():
	return 0 if max_health <= 0 else min(current_health / max_health, 1)


func update_health_bar():
	if max_health == current_health:
		health_bar.visible = false
	elif (!health_bar.visible):
		health_bar.visible = true
	health_bar.value = get_health_precent()	


func on_health_changed():
	update_health_bar()
