extends Node

signal gems_updated(collected: int, required: int)
signal timer_updated(seconds_left: int)
signal all_gems_collected
signal run_won
signal run_lost
signal player_caught(message: String)
signal game_saved
signal game_loaded

@export var required_gems: int = 10
@export var starting_time_seconds: int = 120

const save_path := "res://User/gridlock_save.cfg"
var collected_gem_ids: Dictionary = {}
var collected_gems: int = 0
var time_left: float
var exit_unlocked: bool = false

var pending_load := false


func _ready() -> void:
	reset_run()


func reset_run() -> void:
	collected_gem_ids.clear()
	collected_gems = 0
	time_left = float(starting_time_seconds)
	exit_unlocked = false

	emit_signal("gems_updated", collected_gems, required_gems)
	emit_signal("timer_updated", int(ceil(time_left)))


func gem_collected(gem_id: String) -> void:
	if collected_gem_ids.has(gem_id):
		return
	collected_gem_ids[gem_id] = true
	collected_gems = collected_gem_ids.size()
	emit_signal("gems_updated", collected_gems, required_gems)

	if collected_gems >= required_gems and not exit_unlocked:
		exit_unlocked = true
		emit_signal("all_gems_collected")


func player_reached_exit() -> void:
	delete_save()
	emit_signal("run_won")


func _process(delta: float) -> void:
	if get_tree().paused:
		return

	if time_left <= 0.0:
		return

	time_left -= delta
	emit_signal("timer_updated", max(int(ceil(time_left)), 0))

	if time_left <= 0.0 and collected_gems < required_gems:
		emit_signal("run_lost")


func player_caught_by_drone() -> void:
	if time_left <= 0.0:
		return

	emit_signal("player_caught", "Caught by a drone! Resetting...")
	get_tree().paused = false
	await get_tree().create_timer(1.2).timeout
	reset_run()
	get_tree().reload_current_scene()


func has_save() -> bool:
	return FileAccess.file_exists(save_path)


func save_game(player: CharacterBody3D = null) -> void:
	var cfg := ConfigFile.new()

	cfg.set_value("run", "collected_ids", collected_gem_ids.keys())
	cfg.set_value("run", "required_gems", required_gems)
	cfg.set_value("run", "time_left", time_left)
	cfg.set_value("run", "exit_unlocked", exit_unlocked)

	if player:
		cfg.set_value("player", "pos_x", player.global_position.x)
		cfg.set_value("player", "pos_y", player.global_position.y)
		cfg.set_value("player", "pos_z", player.global_position.z)
		cfg.set_value("player", "rot_y", player.rotation.y)

	var err := cfg.save(save_path)
	if err != OK:
		push_error("Save failed: %s" % err)
	else:
		print("Saved game to: ", save_path)
	emit_signal("game_saved")


func load_game(player: CharacterBody3D = null) -> bool:
	var cfg := ConfigFile.new()
	var err := cfg.load(save_path)
	if err != OK:
		print("No save found.")
		return false

	exit_unlocked = bool(cfg.get_value("run", "exit_unlocked", false))
	time_left = float(cfg.get_value("run", "time_left", float(starting_time_seconds)))

	collected_gem_ids.clear()
	var ids: Array = cfg.get_value("run", "collected_ids", [])
	for id in ids:
		collected_gem_ids[str(id)] = true

	collected_gems = collected_gem_ids.size()
	emit_signal("gems_updated", collected_gems, required_gems)
	emit_signal("timer_updated", int(ceil(time_left)))

	if exit_unlocked:
		emit_signal("all_gems_collected")

	if player:
		var x := float(cfg.get_value("player", "pos_x", player.global_position.x))
		var y := float(cfg.get_value("player", "pos_y", player.global_position.y))
		var z := float(cfg.get_value("player", "pos_z", player.global_position.z))
		player.global_position = Vector3(x, y, z)

		var rot_y := float(cfg.get_value("player", "rot_y", player.rotation.y))
		player.rotation.y = rot_y

	print("Loaded game from: ", save_path)
	apply_loaded_world_state()
	emit_signal("game_loaded")
	return true

func get_player_from_group() -> CharacterBody3D:
	for n in get_tree().get_nodes_in_group("player"):
		if n is CharacterBody3D:
			return n
	return null

func delete_save() -> void:
	if FileAccess.file_exists(save_path):
		DirAccess.remove_absolute(save_path)
	
	pending_load = false

func apply_loaded_world_state() -> void:
	for gem in get_tree().get_nodes_in_group("gems"):
		if gem and gem.has_meta("gem_id"):
			var id := str(gem.get_meta("gem_id"))
			if collected_gem_ids.has(id):
				gem.queue_free()
