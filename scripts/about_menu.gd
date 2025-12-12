extends Control

@onready var back_button: Button = $CenterContainer/VBox/VBox/BackButton

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	back_button.pressed.connect(_on_back_pressed)

func _on_back_pressed() -> void:
	MusicManager.play_button_music()
	get_tree().change_scene_to_file("res://UserInterfaces/MainMenu.tscn")
