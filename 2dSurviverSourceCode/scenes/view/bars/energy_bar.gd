extends CanvasLayer



@onready var progress_bar: ProgressBar = $ProgressBar
@onready var label = $ProgressBar/Label


@export var player: Player
@export var floating_text: PackedScene

func _ready():
	player.energy_component.energy_changed.connect(on_energy_changed)
	player.energy_component.no_energy.connect(on_no_energy)
	update_energy_bar()


func update_energy_bar():
	progress_bar.min_value = 0
	progress_bar.max_value = player.energy_component.max_energy
	progress_bar.value = player.energy_component.current_energy
	label.text = "Energy: %3d / %3d" % [player.energy_component.current_energy, player.energy_component.max_energy]


func put_floating_text(is_positive: bool, value: float):
	if is_positive:
		return
	var instance = floating_text.instantiate()
	progress_bar.add_child(instance)
	
	instance.global_position = label.global_position
	instance.global_position.x += 300
	
	instance.start(is_positive, value)
	
func animate_no_energy():
	var tween = create_tween().set_parallel(true)
	tween.tween_property(label, "theme_override_colors/font_color", Color.RED, 0.3)
	tween.tween_property(label, "theme_override_font_sizes/font_size", 25, 0.3)
	tween.chain()
	tween.tween_property(label, "theme_override_font_sizes/font_size", 20, 0.3)
	tween.tween_property(label, "theme_override_colors/font_color", Color.WHITE, 0.1)
	
func on_energy_changed(is_positive: bool, amount: float):
	put_floating_text(is_positive, amount)
	update_energy_bar()


func on_no_energy():
	animate_no_energy()
