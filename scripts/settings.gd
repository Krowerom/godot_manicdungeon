extends Node

const CONFIG_PATH := "user://settings.cfg"

var MasterVolume: float = 0.0
var MusicVolume: float = 0.0
var SFXVolume: float = 0.0

var currentLevel: int = 1

func _ready() -> void:
	load_settings()
	apply_audio()

func set_mastervolume(value: float) -> void:
	MasterVolume = value
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), MasterVolume)

func set_musicvolume(value: float) -> void:
	MusicVolume = value
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), MusicVolume)

func set_sfxvolume(value: float) -> void:
	SFXVolume = value
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), SFXVolume)

func apply_audio() -> void:
	set_mastervolume(MasterVolume)
	set_musicvolume(MusicVolume)
	set_sfxvolume(SFXVolume)

func save_settings() -> void:
	var config := ConfigFile.new()
	config.set_value("audio","MasterVolume", MasterVolume)
	config.set_value("audio","MusicVolume", MusicVolume)
	config.set_value("audio","SFXVolume", SFXVolume)
	config.save(CONFIG_PATH)

func load_settings() -> void:
	var config := ConfigFile.new()
	var err := config.load(CONFIG_PATH)
	
	if err == OK:
		MasterVolume = config.get_value(
			"audio",
			"MasterVolume",
			0.0
		)
		MusicVolume = config.get_value(
			"audio",
			"MusicVolume",
			0.0
		)
		SFXVolume = config.get_value(
			"audio",
			"SFXVolume",
			0.0
		)
	else:
		MasterVolume = 0.0
		MusicVolume = 0.0
		SFXVolume = 0.0
