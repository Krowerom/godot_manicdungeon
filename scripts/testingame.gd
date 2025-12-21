extends Control

signal speed_changed(new_speed: float)

const WalkSpeed := {
	0: 1000,
	1: 1,
	2: 0.6,
	3: 0.35,
	4: 0.27,
	5: 0.2
}
@onready var positiveSound: AudioStreamPlayer = $Sounds/Positive

func _on_speed_0_pressed() -> void:
	positiveSound.play()
	print("SetSpeed:",WalkSpeed[0])
	speed_changed.emit(WalkSpeed[0])

func _on_speed_1_pressed() -> void:
	positiveSound.play()
	print("SetSpeed:",WalkSpeed[1])
	speed_changed.emit(WalkSpeed[1])

func _on_speed_2_pressed() -> void:
	positiveSound.play()
	print("SetSpeed:",WalkSpeed[2])
	speed_changed.emit(WalkSpeed[2])

func _on_speed_3_pressed() -> void:
	positiveSound.play()
	print("SetSpeed:",WalkSpeed[3])
	speed_changed.emit(WalkSpeed[3])

func _on_speed_4_pressed() -> void:
	positiveSound.play()
	print("SetSpeed:",WalkSpeed[4])
	speed_changed.emit(WalkSpeed[4])

func _on_speed_5_pressed() -> void:
	positiveSound.play()
	print("SetSpeed:",WalkSpeed[5])
	speed_changed.emit(WalkSpeed[5])
