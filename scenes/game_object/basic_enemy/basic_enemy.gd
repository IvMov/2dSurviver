extends CharacterBody2D

@export_range(0, 1) var coin_drop_chance: float = 0.2
const MAX_SPEED = 50
var EXP = 10 * ceil(randf()*10)
var COINS = ceil(randf()*10)
@onready var health_component: HealthComponent = $HealthComponent



# Called when the node enters the scene tree for the first time.
func _ready():
	$HealthComponent.died.connect(on_dead_drop)
	$Area2D.area_entered.connect(on_area_2d_area_entered)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var direction = get_direction_to_player()
	velocity = direction * (MAX_SPEED * ceil(randf()+ 0.2))
	move_and_slide()


func get_direction_to_player():
	var player_nodes = get_tree().get_first_node_in_group("player") as Node2D
	if player_nodes != null:
		return (player_nodes.global_position - global_position).normalized()
	return Vector2.ZERO	


func on_area_2d_area_entered(area):
	health_component.damage(5)

func on_dead_drop():
	GameEvents.emit_exp_dropped(EXP, global_position)
	EnemyCounter.minus_enemy()
	# 0.8 ->  20% chance of drop the coin
	if randf() > 1 - coin_drop_chance: 
		GameEvents.emit_coin_dropped(COINS, global_position)
