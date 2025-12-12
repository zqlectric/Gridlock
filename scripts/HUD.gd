extends CanvasLayer

@onready var timer_label: Label = $TopRight/TimerLabel
@onready var gem_label: Label = $TopRight/GemLabel
@onready var center_message: Label = $VBox/CenterMessage
@onready var mainmenu: Button = $VBox/MainMenu
@onready var restart: Button = $VBox/Restart

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED

	center_message.visible = false
	restart.visible = false
	mainmenu.visible = false

	GameManager.gems_updated.connect(_on_gems_updated)
	GameManager.timer_updated.connect(_on_timer_updated)
	GameManager.run_won.connect(_on_run_won)
	GameManager.run_lost.connect(_on_run_lost)

	_on_gems_updated(GameManager.collected_gems, GameManager.required_gems)
	_on_timer_updated(int(GameManager.time_left))

	mainmenu.pressed.connect(_on_menu_pressed)
	restart.pressed.connect(_on_restart_pressed)

func _on_gems_updated(collected: int, required: int) -> void:
	gem_label.text = "Gems: %d / %d" % [collected, required]

func _on_timer_updated(seconds_left: int) -> void:
	timer_label.text = "Time: %d" % seconds_left
	
func _on_all_gems_collected() -> void:
	center_message.text = "Exit Unlocked!"
	center_message.visible = true

func _on_run_won() -> void:
	center_message.text = "YOU ESCAPED!"
	center_message.visible = true
	mainmenu.visible = true
	restart.visible = true
	mainmenu.grab_focus()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().paused = true

func _on_run_lost() -> void:
	center_message.text = "TIME UP!"
	center_message.visible = true
	mainmenu.visible = true
	restart.visible = true
	mainmenu.grab_focus()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().paused = true

func _on_restart_pressed() -> void:
	MusicManager.play_button_music()
	get_tree().paused = false
	GameManager.reset_run()
	get_tree().reload_current_scene()

func _on_menu_pressed() -> void:
	MusicManager.play_button_music()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://UserInterfaces/MainMenu.tscn")
