extends CharacterBody2D

@onready var health_component = $HealthComponent
@onready var health_bar = $HealthBar

const MAX_SPEED = 55

func _ready():
	health_component.max_health = 10 + (randf() * 5)
	health_component.current_health = health_component.max_health
	health_component.health_changed.connect(on_health_changed)
	
	update_health_bar()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var direction = get_direction_to_player()
	velocity = direction * (MAX_SPEED * ceil(randf()+ 0.2))
	move_and_slide()


func get_direction_to_player():
	var player_node = get_tree().get_first_node_in_group("player") as Node2D
	if player_node != null:
		return (player_node.global_position - global_position).normalized()
	return Vector2.ZERO	
	
	
func update_health_bar():
	if health_component.max_health == health_component.current_health:
		health_bar.visible = false
	elif (!health_bar.visible):
		health_bar.visible = true
	health_bar.value = health_component.get_health_precent()	

	
func on_health_changed():
	update_health_bar()
