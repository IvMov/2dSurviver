extends CanvasLayer

@export var packed_permanent_upgrade_card: PackedScene

@onready var upgrades = $MarginContainer/ColorRect/VBoxContainer/MarginContainer/UpgradeContainer/Upgrades
@onready var back_button = $MarginContainer/ColorRect/VBoxContainer/MarginContainer/HBoxContainer/BackButton
@onready var reset_button = $MarginContainer/ColorRect/VBoxContainer/MarginContainer/HBoxContainer/ResetButton

@onready var money_label = $MarginContainer/ColorRect/VBoxContainer/MarginContainer/StatsContainer/HBoxContainer/Values/MoneyLabel
@onready var games_label = $MarginContainer/ColorRect/VBoxContainer/MarginContainer/StatsContainer/HBoxContainer/Values/GamesLabel
@onready var wins_label = $MarginContainer/ColorRect/VBoxContainer/MarginContainer/StatsContainer/HBoxContainer/Values/WinsLabel
@onready var best_time_label = $MarginContainer/ColorRect/VBoxContainer/MarginContainer/StatsContainer/HBoxContainer/Values/BestTimeLabel
@onready var enemies_killed_label = $MarginContainer/ColorRect/VBoxContainer/MarginContainer/StatsContainer/HBoxContainer/Values/EnemiesKilledLabel
@onready var regen_hp_label = $MarginContainer/ColorRect/VBoxContainer/MarginContainer/StatsContainer/HBoxContainer/Values/RegenHpLabel
@onready var basic_sword_dmg_label = $MarginContainer/ColorRect/VBoxContainer/MarginContainer/StatsContainer/HBoxContainer/Values/BasicSwordDmgLabel
@onready var basic_axe_dmg_label = $MarginContainer/ColorRect/VBoxContainer/MarginContainer/StatsContainer/HBoxContainer/Values/BasicAxeDmgLabel

var active_upgrades: Dictionary


func _ready():
	update_labels()
	GameEvents.permanent_upgrade_buy.connect(on_permanent_upgrade_buy)
	back_button.pressed.connect(on_back_button_pressed)
	reset_button.pressed.connect(on_reset_button_pressed)
	for upgrade in MetaProgression.permanent_upgrade_pool:
		var permanent_upgrade = packed_permanent_upgrade_card.instantiate() as PermanentUpgradeCard
		permanent_upgrade.upgrade = upgrade
		upgrades.add_child(permanent_upgrade)

		
func _unhandled_input(event):
	if event.is_action_pressed("escape"):
		on_back_button_pressed()


func calc_current_upgrade_value(skill: Dictionary):
	return skill["base"] + skill["lvl"] * skill["value"]

	
func update_shop():
	var children = upgrades.get_children()
	for child in children:
		if child is PermanentUpgradeCard:
			child.update_info()


func update_labels():
	money_label.text = "%d $" % MetaProgression.meta_data["coins"]
	games_label.text = "%08d" % MetaProgression.meta_data["runs"]
	wins_label.text = "%08d" % MetaProgression.meta_data["win_runs"]
	best_time_label.text = GameEvents.format_seconds_to_sring(MetaProgression.meta_data["best_time"])
	enemies_killed_label.text = "%08d" % MetaProgression.meta_data["kills"]
	active_upgrades = MetaProgression.meta_data["upgrades"];
	regen_hp_label.text = "%0.1f" % calc_current_upgrade_value(active_upgrades["hp_regen"])
	basic_sword_dmg_label.text = "%d" % calc_current_upgrade_value(active_upgrades["sword_dmg"])
	basic_axe_dmg_label.text = "%d" % calc_current_upgrade_value(active_upgrades["axe_dmg"])
	

func on_permanent_upgrade_buy(upgrade: MetaUpgrade):
	update_labels()
	update_shop()


func on_reset_button_pressed():
	MetaProgression.reset_file();
	update_labels()
	update_shop()


func on_back_button_pressed():
	GameEvents.emit_save_game()
	queue_free()

func on_upgrade_load_failed():
	on_reset_button_pressed()
