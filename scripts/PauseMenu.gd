extends CanvasLayer

@onready var title_label: Label      = $VBox/TitleLabel
@onready var resume_button: Button   = $VBox/ResumeButton
@onready var restart_button: Button  = $VBox/RestartButton
@onready var quit_button: Button     = $VBox/QuitButton
@onready var dimmer: ColorRect       = $Dimmer

var is_open: bool = false

func _ready() -> void:
	process_mode = Node.ProcessMode.PROCESS_MODE_WHEN_PAUSED

	hide()
	dimmer.visible = false
	is_open = false

	resume_button.pressed.connect(_on_resume_pressed)
	restart_button.pressed.connect(_on_restart_pressed)
	quit_button.pressed.connect(_on_quit_pressed)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		if is_open:
			close()
		else:
			open()
		get_viewport().set_input_as_handled()


func open() -> void:
	is_open = true
	show()
	dimmer.visible = true
	get_tree().paused = true
	resume_button.grab_focus()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func close() -> void:
	is_open = false
	hide()
	dimmer.visible = false
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _on_resume_pressed() -> void:
	MusicManager.play_button_music()
	close()


func _on_restart_pressed() -> void:
	MusicManager.play_button_music()
	get_tree().paused = false
	GameManager.reset_run()
	get_tree().reload_current_scene()


func _on_quit_pressed() -> void:
	MusicManager.play_button_music()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://UserInterfaces/MainMenu.tscn")
