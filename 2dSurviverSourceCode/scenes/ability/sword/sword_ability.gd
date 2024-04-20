extends Node2D
class_name SwordAbility


@onready var sword_animation = $SwordAnimation
@onready var collision_shape_2d = $HitboxComponent/CollisionShape2D
@onready var sprite_2d = $Sprite2D
@onready var hitbox_component: HitboxComponent = $HitboxComponent

var scale_factor = 1;

func _process(delta):
	sword_animation.play("swing_%d" % scale_factor)
	
