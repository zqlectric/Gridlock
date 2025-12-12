extends Area3D

@export var spin_speed: float = 60.0
@export var float_amplitude: float = 0.2
@export var float_speed: float = 2.0
@export var move_speed: float = 5.0

@export var patrol_distance: float = 12.0
@export var patrol_direction: Vector3 = Vector3(1, 0, 0)

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

	for node in get_tree().get_nodes_in_group("player"):
		_player = node

func _physics_process(delta: float) -> void:
	rotate_y(deg_to_rad(spin_speed * delta))

	var pos = global_transform.origin
	pos.y = _base_y + sin(Time.get_ticks_msec() / 1000.0 * float_speed) * float_amplitude

	var dir = (_target_pos - pos).normalized()
	pos += dir * move_speed * delta

	global_transform.origin = pos

	if pos.distance_to(_target_pos) < 0.2:
		_target_pos = _point_a_pos if _target_pos == _point_b_pos else _point_b_pos

func _on_body_entered(body: Node) -> void:
	if body is CharacterBody3D:
		MusicManager.play_orb_music()
		GameManager.player_caught_by_drone()
