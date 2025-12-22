extends Node
class_name health

signal on_change (current: int, max: int)
signal on_take_damage ()
signal on_die ()

enum PostDeath {DestroyNode, DeathScene}

var current: int
@export var maxhealth : int = 100
@export var post_death_action : PostDeath
@export var drop_on_death : PackedScene

func _ready() -> void:
	current = maxhealth

func take_damage(amount: int):
	current -= amount
	on_change.emit(current, maxhealth)
	on_take_damage.emit()
	if current <= 0:
		die()

func die():
	on_die.emit()
	if drop_on_death != null:
		var drop = drop_on_death.instantiate()
		get_node("/root/").add_child(drop)
		drop.position = get_parent().position
	if post_death_action == PostDeath.DestroyNode:
		get_parent().queue_free()
	elif post_death_action == PostDeath.DeathScene:
		get_tree().change_scene_to_file("res://scenes/death.tscn")
		#get_tree().reload_current_scene()

func heal (amount: int):
	current += amount
	if current > maxhealth:
		current = maxhealth
	on_change.emit(current,maxhealth)
