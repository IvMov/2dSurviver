extends Node2D

@export var health_component: Node
@export var sprite: Sprite2D


func _ready():
	$GPUParticles2D.texture = sprite.texture
	health_component.died.connect(on_died)


func on_died():
	if !owner || not owner is Node2D:
		return
	
	print(owner.global_position)
	var entities = get_tree().get_first_node_in_group("entities_layer")
	#get_parent().remove_child(self)
	global_position = owner.global_position
	print(self.global_position)
	entities.add_child(self)
	

	$AnimationPlayer.play("default")
	
