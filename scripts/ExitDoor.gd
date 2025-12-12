extends Node3D

@onready var door_body: CollisionShape3D = $DoorBody/CollisionShape3D
@onready var trigger: Area3D = $Trigger

var is_unlocked: bool = false

func _ready() -> void:
	GameManager.all_gems_collected.connect(_on_all_gems_collected)
	trigger.body_entered.connect(_on_trigger_body_entered)

func _on_all_gems_collected() -> void:
	is_unlocked = true
	if is_instance_valid(door_body):
		door_body.queue_free()

func _on_trigger_body_entered(body: Node) -> void:
	if not is_unlocked:
		return

	if body is CharacterBody3D:
		MusicManager.play_door_music()
		GameManager.player_reached_exit()
