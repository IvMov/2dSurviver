extends Area2D
class_name HurtboxComponent

@export var health_component: HealthComponent
@onready var animation_player = $"../AnimationPlayer"
@onready var timer = $Timer

var floating_text_scene = preload("res://scenes/view/floating_text.tscn")


func _ready():
	area_entered.connect(on_area_entered)
	
	
func on_area_entered(other_area: Area2D):
	if !timer.is_stopped():
		return
	if not other_area is HitboxComponent:
		return
	var hitbox_component = other_area as HitboxComponent
	var damage = hitbox_component.damage
	health_component.damage(damage)
	if !animation_player:
		return
	animation_player.play("damaged")
	var floating_text = floating_text_scene.instantiate() as Node2D
	get_tree().get_first_node_in_group("foreground_layer").add_child(floating_text)
	floating_text.global_position = global_position
	floating_text.start(str(damage))
	timer.start()
	
