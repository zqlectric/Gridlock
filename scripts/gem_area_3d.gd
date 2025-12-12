extends Area3D

@onready var visual: Node3D = $gem
@onready var shape: CollisionShape3D = $CollisionShape3D
@onready var light: OmniLight3D = $OmniLight3D
var _collected: bool = false

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	add_to_group("gems")


func _on_body_entered(body: Node) -> void:
	if _collected:
		return
	if body is CharacterBody3D:
		MusicManager.play_gem_music()
		_collected = true
		var id := str(get_parent().get_meta("gem_id"))
		print(get_parent().get_meta("gem_id"))
		GameManager.gem_collected(id);
		_start_disappear()


func _start_disappear() -> void:
	monitoring = false
	if shape:
		shape.disabled = true

	var tween := create_tween()

	tween.tween_property(
		visual, "scale",
		Vector3.ZERO,
		0.3
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)

	if light:
		tween.parallel().tween_property(
			light, "light_energy",
			0.0,
			0.3
		)

	tween.finished.connect(queue_free)
