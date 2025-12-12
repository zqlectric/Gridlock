extends CharacterBody3D

@export var move_speed: float = 6.0
@export var sprint_multiplier: float = 1.5
@export var jump_force: float = 4.0
@export var gravity: float = 12.0
@export var mouse_sensitivity: float = 0.003
@export var base_fov: float = 75.0
@export var sprint_fov: float = 85.0
@export var fov_lerp_speed: float = 8.0

@onready var cam: Camera3D = $Camera3D

var pitch: float = 0.0

var step_interval := 0.4
var _step_timer := 0.0

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	cam.fov = base_fov

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and \
		Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:

		rotate_y(-event.relative.x * mouse_sensitivity)

		pitch = clamp(
			pitch - event.relative.y * mouse_sensitivity,
			-1.2,
			1.2
		)
		cam.rotation.x = pitch

func _physics_process(delta: float) -> void:
	var forward: Vector3 = -global_transform.basis.z
	var right: Vector3 = global_transform.basis.x

	var input_vec := Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_forward") - Input.get_action_strength("move_back")
	)

	var move_dir := Vector3.ZERO
	if input_vec.length() > 0.0:
		input_vec = input_vec.normalized()
		move_dir = (forward * input_vec.y + right * input_vec.x).normalized()

	var speed := move_speed
	if Input.is_action_pressed("sprint"):
		speed *= sprint_multiplier
	
	var target_fov := base_fov
	if Input.is_action_pressed("sprint") and move_dir.length() > 0.1:
		target_fov = sprint_fov
	cam.fov = lerp(cam.fov, target_fov, fov_lerp_speed * delta)

	var v := velocity
	v.x = move_dir.x * speed
	v.z = move_dir.z * speed
	
	if move_dir.length() > 0.1 and is_on_floor():
		_step_timer -= delta
		if _step_timer <= 0:
			MusicManager.play_footsteps_music()
			_step_timer = step_interval / (speed / move_speed)  # faster when sprinting
	else:
		_step_timer = 0.0

	if not is_on_floor():
		v.y -= gravity * delta
	elif Input.is_action_just_pressed("jump"):
		v.y = jump_force
	else:
		v.y = 0.0

	velocity = v
	move_and_slide()
