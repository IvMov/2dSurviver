extends CanvasLayer

@onready var progress_bar: ProgressBar = $ProgressBar
@onready var label = $ProgressBar/Label


func _ready():
	progress_bar.min_value = PlayerCounters.start_expirience
	progress_bar.max_value = PlayerCounters.target_expirience
	GameEvents.new_level.connect(rescale_on_level_up)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	progress_bar.value = PlayerCounters.expirience
	label.text = "EXP: %10d / %10d" % [PlayerCounters.expirience, PlayerCounters.target_expirience]


func rescale_on_level_up(newValue):
	progress_bar.min_value = PlayerCounters.start_expirience
	progress_bar.max_value = PlayerCounters.target_expirience
