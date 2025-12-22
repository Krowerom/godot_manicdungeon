extends CharacterBody2D
class_name Player

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var walkSound: AudioStreamPlayer = $Sounds/Step
@onready var testingmenu: Control = $"../CanvasLayer/testingame"

const TILE_SIZE := 32
const COLLISION_MASK := 1   # wall layer
var MOVE_DURATION := 0.35  # seconds per tile

var start_position: Vector2
var target_position: Vector2
var is_moving := false
var move_dir := Vector2.ZERO
var move_timer := 0.0



func _ready() -> void:
	print(testingmenu)
	var curSpeed = MOVE_DURATION
	_setSpeed(10000) #make it sloooow
	await get_tree().create_timer(0.25).timeout
	_setSpeed(curSpeed) #restore speed
	global_position = global_position.snapped(Vector2(TILE_SIZE, TILE_SIZE))
	start_position = global_position
	target_position = global_position
	if testingmenu:
		testingmenu.speed_changed.connect(_setSpeed)

func _setSpeed(speed : float):
	MOVE_DURATION = speed

func _physics_process(delta: float) -> void:
	if is_moving:
		move_towards_target(delta)
	else:
		walkSound.play()
		handle_continuous_input()

func handle_continuous_input() -> void:
	move_dir = Vector2.ZERO

	if Input.is_action_pressed("right"):
		move_dir = Vector2.RIGHT
	elif Input.is_action_pressed("left"):
		move_dir = Vector2.LEFT
	elif Input.is_action_pressed("up"):
		move_dir = Vector2.UP
	elif Input.is_action_pressed("down"):
		move_dir = Vector2.DOWN
	else:
		animated_sprite.play("idle")
		return

	try_start_move(move_dir)

func try_start_move(dir: Vector2) -> void:
	var new_position = global_position + dir * TILE_SIZE

	# Collision check using PhysicsRayQueryParameters2D
	var ray = PhysicsRayQueryParameters2D.new()
	ray.from = global_position
	ray.to = new_position
	ray.exclude = [self]
	ray.collision_mask = COLLISION_MASK

	var collision = get_world_2d().direct_space_state.intersect_ray(ray)

	if collision.size() == 0:  # no collision
		start_position = global_position
		target_position = new_position
		move_timer = 0.0
		is_moving = true
		play_walk_animation(dir)

func move_towards_target(delta: float) -> void:
	move_timer += delta
	var t = move_timer / MOVE_DURATION
	if t > 1.0:
		t = 1.0

	global_position = start_position + (target_position - start_position) * t

	if t >= 1.0:
		global_position = target_position
		is_moving = false

func play_walk_animation(dir: Vector2) -> void:
	match dir:
		Vector2.RIGHT:
			animated_sprite.play("walk_right")
		Vector2.LEFT:
			animated_sprite.play("walk_left")
		Vector2.UP:
			animated_sprite.play("walk_right")
		Vector2.DOWN:
			animated_sprite.play("walk_left")
