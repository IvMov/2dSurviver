extends Node2D


@onready var label = $Label


func _ready():
	pass


func start(text_number: float):
	var text = "%0.1f" % text_number
	label.text = text
	var tween = create_tween()
	
	
	tween.tween_property(self, "global_position", global_position + (Vector2.UP * 16), .3)\
	.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "scale", Vector2.ONE * 1.5, .3)\
	.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	tween.chain()
	tween.tween_property(self, "scale",Vector2.ZERO, .4)
	
	tween.tween_callback(queue_free)

