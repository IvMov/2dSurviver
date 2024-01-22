extends CanvasLayer

@onready var progress_bar: ProgressBar = $MarginContainer/ProgressBar
# Called when the node enters the scene tree for the first time.
func _ready():
	progress_bar.min_value = PlayerCounters.start_expirience
	progress_bar.max_value = PlayerCounters.target_expirience
	PlayerCounters.target_changed.connect(rescale_on_level_up)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	progress_bar.value = PlayerCounters.expirience


func rescale_on_level_up():
	progress_bar.min_value = PlayerCounters.start_expirience
	progress_bar.max_value = PlayerCounters.target_expirience
