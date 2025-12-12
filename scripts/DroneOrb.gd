extends Area3D

@export var spin_speed: float = 60.0
@export var float_amplitude: float = 0.2
@export var float_speed: float = 2.0
@export var move_speed: float = 5.0

@export var patrol_distance: float = 12.0
@export var patrol_direction: Vector3 = Vector3(1, 0, 0)

@export var idle_time_at_point: float = 1.5
var _is_waiting := false

@onready var anim: AnimationPlayer = $AnimationPlayer

var _player: CharacterBody3D = null
var _base_y: float
var _start_pos: Vector3
var _point_a_pos: Vector3
var _point_b_pos: Vector3
var _target_pos: Vector3

func _ready() -> void:
	_base_y = global_transform.origin.y
	_start_pos = global_transform.origin

	var dir = patrol_direction.normalized()
	_point_a_pos = _start_pos - dir * patrol_distance
	_point_b_pos = _start_pos + dir * patrol_distance
	_target_pos = _point_b_pos

	body_entered.connect(_on_body_entered)

	if anim and anim.has_animation("patrol"):
		anim.play("patrol")
	elif anim and anim.has_animation("idle_hover"):
		anim.play("idle_hover")

func _physics_process(delta: float) -> void:
	if _is_waiting:
		return
	rotate_y(deg_to_rad(spin_speed * delta))
	var pos = global_transform.origin
	pos.y = _base_y + sin(Time.get_ticks_msec() / 1000.0 * float_speed) * float_amplitude
	var dir = (_target_pos - pos).normalized()
	pos += dir * move_speed * delta
	global_transform.origin = pos
	if pos.distance_to(_target_pos) < 0.2:
		_reach_patrol_point()

func _on_body_entered(body: Node) -> void:
	if body is CharacterBody3D:
		_is_waiting = true
		if anim and anim.has_animation("alert"):
			anim.play("alert")
		MusicManager.play_orb_music()
		GameManager.player_caught_by_drone()
		await get_tree().create_timer(1.2).timeout
		_is_waiting = false

func _reach_patrol_point() -> void:
	_is_waiting = true
	if anim and anim.has_animation("idle_hover"):
		anim.play("idle_hover")
	await get_tree().create_timer(idle_time_at_point).timeout
	_target_pos = _point_a_pos if _target_pos == _point_b_pos else _point_b_pos
	if anim and anim.has_animation("patrol"):
		anim.play("patrol")
	_is_waiting = false
