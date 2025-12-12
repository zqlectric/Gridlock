extends Node3D

@onready var pause_menu = $PauseMenu

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
