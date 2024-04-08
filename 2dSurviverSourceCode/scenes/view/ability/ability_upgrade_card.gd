extends PanelContainer

signal card_selected()

@onready var header_label: Label = %Header
@onready var description_label: Label = %Description
@onready var color_rect: ColorRect = %ColorRect
@onready var animation_player = $AnimationPlayer
@onready var hover_audio_player_component = $HoverAudioPlayerComponent
@onready var click_audio_player_component = $ClickAudioPlayerComponent


var tween: Tween

func _ready():
	gui_input.connect(on_gui_input)
	mouse_entered.connect(on_mouse_entered)

func set_ability_upgrade(upgrade: AbilityUpgrade):
	if !upgrade:
		return
	header_label.set_self_modulate(upgrade.main_color)
	header_label.text = upgrade.name
	description_label.text = upgrade.description
	color_rect.set_color(upgrade.main_color)

func play_hover():
	if tween:
		tween.kill()
	if hover_audio_player_component.playing:
		hover_audio_player_component.stop()
	hover_audio_player_component.play_random_stream()
	
	tween = create_tween()
	tween.tween_property(self, "rotation", -0.02, 0.1)
	tween.tween_property(self, "scale", Vector2.ONE * 1.02, 0.1)
	tween.chain()
	tween.tween_property(self, "rotation", 0.00, 0.1)
	tween.tween_property(self, "scale", Vector2.ONE, 0.1)
	
	
	

func play_selected():
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(self, "scale", Vector2.ONE * 1.5, 0.1)
	tween.chain()
	tween.tween_property(self, "scale", Vector2.ZERO, 0.1)


func play_unselected():
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(self, "scale", Vector2.ZERO, 0.1)
	
	
func select_card():
	click_audio_player_component.play_random_stream()
	get_tree().get_first_node_in_group("upgrade_screen").disable_inputs = true
	play_selected()
	await tween.finished
	card_selected.emit()
	queue_free()
	
func on_gui_input(event: InputEvent):
	if get_tree().get_first_node_in_group("upgrade_screen").disable_inputs:
		return
	if event.is_action_pressed("left_click"):
		select_card()


func on_mouse_entered():
	if get_tree().get_first_node_in_group("upgrade_screen").disable_inputs:
		return
	play_hover()
	await tween.finished

