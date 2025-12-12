extends Node3D

@onready var pause_menu = $PauseMenu

func _ready() -> void:
	if GameManager.pending_load:
		GameManager.pending_load = false
		var player := get_tree().get_first_node_in_group("player") as CharacterBody3D
		GameManager.load_game(player)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		if get_tree().paused:
			resume_game()
		else:
			pause_game()

func pause_game() -> void:
	get_tree().paused = true
	pause_menu.show()

func resume_game() -> void:
	get_tree().paused = false
	pause_menu.hide()
