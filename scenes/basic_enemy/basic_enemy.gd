extends CharacterBody2D

const MAX_SPEED = 40
# Called when the node enters the scene tree for the first time.
func _ready():
	$Area2D.area_entered.connect(on_area_2d_area_entered)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var direction = get_direction_to_player()
	velocity = direction * (MAX_SPEED * get_randog_factor())
	move_and_slide()


func get_direction_to_player():
	var player_nodes = get_tree().get_first_node_in_group("player") as Node2D
	if player_nodes != null:
		return (player_nodes.global_position - global_position).normalized()
	return Vector2.ZERO	


func on_area_2d_area_entered(area):
	queue_free()
	EnemyCounter.minus_enemy()
	PlayerCounters.add_money()
	PlayerCounters.add_exp()

func get_randog_factor():
	var rng = RandomNumberGenerator.new()
	return rng.randf_range(0.2, 2)
