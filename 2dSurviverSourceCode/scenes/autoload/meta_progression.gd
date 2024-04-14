extends Node

const FILE_PATH = "user://2d_survivor.save"
var empty_meta_data: Dictionary = {
	"runs": 0,
	"win_runs" : 0,
	"coins": 0,
	"upgrades": {}
} 

var meta_data: Dictionary

func _ready():
	init_meta_data()
	
	GameEvents.coin_collected.connect(on_coin_collected)
	GameEvents.game_started.connect(on_game_started)
	GameEvents.game_win.connect(on_game_win)
	
func init_meta_data():
	meta_data = empty_meta_data.duplicate()
	get_file()
	print(meta_data)
	
func get_file():
	if !FileAccess.file_exists(FILE_PATH):
		return
	var file = FileAccess.open(FILE_PATH, FileAccess.READ)
	meta_data = file.get_var()

func save_file():
	var file = FileAccess.open(FILE_PATH, FileAccess.WRITE)
	file.store_var(meta_data)
	
func reset_file():
	if !FileAccess.file_exists(FILE_PATH):
		return
	var file = FileAccess.open(FILE_PATH, FileAccess.WRITE)
	file.store_var(empty_meta_data)
	file.close()
	init_meta_data()
	
	
func add_upgrade(upgrade: MetaUpgrade):
	if !meta_data["upgrades"].has(upgrade.id):
		meta_data["upgrades"][upgrade.id] = {
			"lvl": 0,
			"title": upgrade.title,
			"description": upgrade.description
		}
	if meta_data["uprgades"][upgrade.id]["lvl"] < upgrade.max_lvl:
		meta_data["upgrades"][upgrade.id]["lvl"] += 1
		

func on_game_started():
	meta_data["runs"] += 1
	save_file()

func on_game_win():
	meta_data["win_runs"] += 1
	save_file()


func on_coin_collected(value: int, position: Vector2):
	meta_data["coins"] += value
	save_file()

