extends Node

signal gems_updated(collected: int, required: int)
signal timer_updated(seconds_left: int)
signal all_gems_collected
signal run_won
signal run_lost

@export var required_gems: int = 10
@export var starting_time_seconds: int = 120

var collected_gems: int = 0
var time_left: float

func _ready() -> void:
	reset_run()

func reset_run() -> void:
	collected_gems = 0
	time_left = float(starting_time_seconds)
	emit_signal("gems_updated", collected_gems, required_gems)
	emit_signal("timer_updated", int(ceil(time_left)))

func gem_collected() -> void:
	collected_gems += 1
	emit_signal("gems_updated", collected_gems, required_gems)
	if collected_gems >= required_gems:
		emit_signal("all_gems_collected")

func player_reached_exit() -> void:
	emit_signal("run_won")

func _process(delta: float) -> void:
	if time_left <= 0.0:
		return

	time_left -= delta
	emit_signal("timer_updated", max(int(ceil(time_left)), 0))

	if time_left <= 0.0 and collected_gems < required_gems:
		emit_signal("run_lost")

func player_caught_by_drone() -> void:
	if time_left <= 0.0:
		return
	get_tree().paused = false
	reset_run()
	get_tree().reload_current_scene()
