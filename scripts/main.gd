extends Control
@onready var positiveSound: AudioStreamPlayer = $Sounds/Positive
@onready var negativeSound: AudioStreamPlayer = $Sounds/Negative
@onready var h_slider_master: HSlider = $"MarginContainer/VBoxContainer/PanelContainer/Menu Contents/Buttons_Sliders/MasterSlider/hSlider_Master"
@onready var h_slider_music: HSlider = $"MarginContainer/VBoxContainer/PanelContainer/Menu Contents/Buttons_Sliders/MusicSlider/hSlider_Music"
@onready var h_slider_sfx: HSlider = $"MarginContainer/VBoxContainer/PanelContainer/Menu Contents/Buttons_Sliders/SFXSlider/hSlider_SFX"

func _ready() -> void:
	h_slider_master.value = Settings.MasterVolume
	h_slider_music.value = Settings.MusicVolume
	h_slider_sfx.value = Settings.SFXVolume

func _on_play_button_pressed() -> void:
	Settings.save_settings()
	positiveSound.play()
	await get_tree().create_timer(0.75).timeout
	get_tree().change_scene_to_file("res://scenes/game.tscn")

func _on_quit_button_pressed() -> void:
	Settings.save_settings()
	negativeSound.play()
	await get_tree().create_timer(1.0).timeout
	get_tree().quit()

func _on_h_slider_master_value_changed(value: float) -> void:
	Settings.set_mastervolume(value)
	#AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"),value)

func _on_h_slider_music_value_changed(value: float) -> void:
	Settings.set_musicvolume(value)
	#AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"),value)

func _on_h_slider_sfx_value_changed(value: float) -> void:
	Settings.set_sfxvolume(value)
	#AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"),value)
