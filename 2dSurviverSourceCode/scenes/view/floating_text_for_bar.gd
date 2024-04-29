extends Node2D

@onready var label: Label = %Label

func start(is_positive: bool, text_number: float):
	var text = "%s%0.1f" % ["+" if is_positive else "-", text_number]
	label.set_text(text)
	label.modulate = Color.GREEN if is_positive else Color.RED	
	var tween = create_tween()
	
	tween.tween_property(self, "scale", Vector2.ONE * 1.5, .5)
	tween.tween_property(self, "global_position", global_position +Vector2.RIGHT * 200, .5)
	tween.tween_property(self, "scale", Vector2.ZERO, .3)
	
	tween.tween_callback(queue_free)

	
