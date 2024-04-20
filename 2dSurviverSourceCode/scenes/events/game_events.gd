extends Node

signal game_started()
signal game_win()
signal exp_collected(value: int, position: Vector2)
signal coin_collected(value: int, position: Vector2)
signal exp_dropped(value: int, position: Vector2)
signal coin_dropped(value: int, position: Vector2)
signal new_level(value: int)
signal call_abillity_upgrade()
signal ability_upgrade_applied()
signal ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary)
signal player_damaged(value: int)
signal window_changed()
signal save_game()
signal permanent_upgrade_buy(upgrade: MetaUpgrade)

var full_screen: bool = true

func _unhandled_input(event):
	if event.is_action("full_screen") && event.is_released():
		full_screen_pressed()
		
func full_screen_pressed():
	var is_fullscreen = DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN
	if is_fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MINIMIZED)
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	full_screen = !is_fullscreen
	emit_window_changed()

func format_seconds_to_sring(seconds: float):
	if !seconds:
		return "00:00"
		
	var minutes = floor(seconds/60)
	var remaining_seconds = floor(seconds) if minutes == 0 else int(seconds) % 60
	
	return ("%02d" % minutes) + ":" + ("%02d" % remaining_seconds) if minutes < 99 else "GAME END"


func emit_game_started():
	game_started.emit()
	
func emit_game_win():
	game_win.emit()

func emit_exp_collected(value: int, position: Vector2):
	exp_collected.emit(value, position)


func emit_coin_collected(value: int, position: Vector2):
	coin_collected.emit(value, position)
	
	
func emit_exp_dropped(value: int, position: Vector2):
	exp_dropped.emit(value, position)


func emit_coin_dropped(value: int, position: Vector2):
	coin_dropped.emit(value, position)


func emit_new_level(value: int):
	new_level.emit(value)


func emit_call_abillity_upgrade():
	call_abillity_upgrade.emit()


func emit_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	ability_upgrade_added.emit(upgrade, current_upgrades)
	
func emit_ability_upgrade_applied():
	ability_upgrade_applied.emit()
	
func emit_player_damaged(value: int):
	player_damaged.emit(value)
	
func emit_window_changed():
	window_changed.emit()
	
func emit_save_game():
	save_game.emit()
	
func emit_permanent_upgrade_buy(upgrade: MetaUpgrade):
	permanent_upgrade_buy.emit(upgrade)
