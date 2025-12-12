extends Control

@onready var play_button: Button = $CenterContainer/VBox/VBox/PlayButton
@onready var about_button: Button = $CenterContainer/VBox/VBox/AboutButton
@onready var howtoplay_button: Button = $CenterContainer/VBox/VBox/HowToPlayButton
@onready var quit_button: Button = $CenterContainer/VBox/VBox/QuitButton

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	play_button.pressed.connect(_on_play_pressed)
	about_button.pressed.connect(_on_about_pressed)
	howtoplay_button.pressed.connect(_on_howtoplay_pressed)
	quit_button.pressed.connect(_on_quit_pressed)

func _on_play_pressed() -> void:
	MusicManager.play_button_music()
	get_tree().change_scene_to_file("res://level.tscn")
	GameManager.reset_run();

func _on_about_pressed() -> void:
	MusicManager.play_button_music()
	get_tree().change_scene_to_file("res://UserInterfaces/AboutMenu.tscn")

func _on_howtoplay_pressed() -> void:
	MusicManager.play_button_music()
	get_tree().change_scene_to_file("res://UserInterfaces/HowToPlay.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
