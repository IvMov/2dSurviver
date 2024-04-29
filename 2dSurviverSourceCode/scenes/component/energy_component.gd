extends Node

signal energy_changed(is_positive: bool, amount: float)
signal no_energy
@export var max_energy: float
@export var current_energy: float 
@export var energy_regen: float
@onready var regen_timer = $RegenTimer


func _ready():
	regen_timer.timeout.connect(on_regen_timer_timeout)

func minus_energy(amount: float) -> bool:
	if current_energy - amount >= 0:
		if regen_timer.is_stopped():
			regen_timer.start()
		current_energy -= amount
		emit_energy_changed(false, amount)
		return true
	emit_no_energy()
	return false
	
func plus_energy(amount: float) -> bool:
	if current_energy == max_energy:
		return false
	current_energy = min(max_energy, current_energy + amount)
	emit_energy_changed(true, amount)
	return true

func increase_max_energy(amount: float) -> void:
	max_energy += amount
	emit_energy_changed(true, 0)
	
func increase_regen(amount: float) -> void:
	energy_regen += amount 
	

func on_regen_timer_timeout():
	plus_energy(energy_regen)
	if current_energy != max_energy:
		regen_timer.start()



func emit_energy_changed(is_positive: bool, amount:float):
	energy_changed.emit(is_positive, amount)

func emit_no_energy():
	no_energy.emit()
