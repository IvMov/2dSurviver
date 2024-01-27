extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().get_first_node_in_group("player").health.died.con


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
