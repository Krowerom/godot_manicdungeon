extends Node2D
@onready var bar: ProgressBar = $ProgressBar
@onready var myhealth: health = get_parent().get_node("Health")

func _ready() -> void:
	bar.max_value = myhealth.maxhealth
	bar.value = myhealth.current
	myhealth.on_change.connect(_on_health_changed)

func _on_health_changed(current: int, maxval: int) -> void:
	bar.max_value = maxval
	bar.value = current
