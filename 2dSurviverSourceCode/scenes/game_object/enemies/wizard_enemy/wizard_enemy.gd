extends BasicEnemy

func _ready():
	super._ready()
	hurt = 3 if PlayerCounters.game_difficulty > 2 else 2
	
#used in animation
func set_is_moving(moving: bool): 
	is_moving = moving

func animate_enemy():
	animation_player.play("walk")
	var direction_look: Vector2 = Vector2(-1, 1) if sign(velocity.x) < 0 else Vector2.ONE
	sprites.set_scale(direction_look)
