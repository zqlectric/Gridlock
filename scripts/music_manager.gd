extends Node

@onready var music_player: AudioStreamPlayer = $MusicPlayer
@onready var gem: AudioStreamPlayer = $GemFound
@onready var button: AudioStreamPlayer = $ButtonClick
@onready var footsteps: AudioStreamPlayer = $Footsteps
@onready var orb: AudioStreamPlayer = $OrbHit
@onready var door: AudioStreamPlayer = $DoorOpening

func _ready() -> void:
	pass

func play_menu_music() -> void:
	music_player.play()

func play_gem_music() -> void:
	gem.play()

func play_button_music() -> void:
	button.play()

func play_footsteps_music() -> void:
	footsteps.play()

func play_orb_music() -> void:
	orb.play()

func play_door_music() -> void:
	door.play()

func stop_music() -> void:
	if music_player.playing:
		music_player.stop()
