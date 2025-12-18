extends Control
@onready var positiveSound: AudioStreamPlayer = $Sounds/Positive

func _on_main_menu_pressed() -> void:
	positiveSound.play()
	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
