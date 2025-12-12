extends Control

@onready var new_button: Button = $CenterContainer/VBox/VBox/NewButton
@onready var load_button: Button = $CenterContainer/VBox/VBox/LoadButton
@onready var about_button: Button = $CenterContainer/VBox/VBox/AboutButton
@onready var howtoplay_button: Button = $CenterContainer/VBox/VBox/HowToPlayButton
@onready var quit_button: Button = $CenterContainer/VBox/VBox/QuitButton

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	load_button.disabled = not GameManager.has_save()

	new_button.pressed.connect(_on_play_pressed)
	load_button.pressed.connect(_on_load_game_pressed)
	about_button.pressed.connect(_on_about_pressed)
	howtoplay_button.pressed.connect(_on_howtoplay_pressed)
	quit_button.pressed.connect(_on_quit_pressed)

func _on_play_pressed() -> void:
	MusicManager.play_button_music()
	GameManager.delete_save()
	GameManager.reset_run()
	get_tree().change_scene_to_file("res://level.tscn")

func _on_about_pressed() -> void:
	MusicManager.play_button_music()
	get_tree().change_scene_to_file("res://UserInterfaces/AboutMenu.tscn")

func _on_howtoplay_pressed() -> void:
	MusicManager.play_button_music()
	get_tree().change_scene_to_file("res://UserInterfaces/HowToPlay.tscn")

func _on_load_game_pressed() -> void:
	MusicManager.play_button_music()
	GameManager.pending_load = true
	get_tree().change_scene_to_file("res://level.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
