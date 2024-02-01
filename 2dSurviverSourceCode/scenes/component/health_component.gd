extends Node
class_name HealthComponent

signal died
signal health_changed

@export var max_health: float
var current_health: float 

	
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
