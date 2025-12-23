extends CharacterBody2D
class_name Enemy

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var step: AudioStreamPlayer = $Sounds/Step

const TILE_SIZE := 32
const COLLISION_MASK := 1

const NORMAL_MOVE_DURATION := 0.35
const WANDER_MOVE_DURATION := NORMAL_MOVE_DURATION * 2.0

var MOVE_DURATION := WANDER_MOVE_DURATION

var start_position: Vector2
var target_position: Vector2
var is_moving := false
var move_dir := Vector2.ZERO
var move_timer := 0.0

var player: Player

func _ready() -> void:
	var curSpeed = MOVE_DURATION
	_setSpeed(10000) #make it sloooow
	await get_tree().create_timer(0.25).timeout
	_setSpeed(curSpeed) #restore speed
	global_position = global_position.snapped(Vector2(TILE_SIZE, TILE_SIZE))
	start_position = global_position
	target_position = global_position
	player = get_tree().get_first_node_in_group("player")

func _setSpeed(speed : float):
	MOVE_DURATION = speed

func _physics_process(delta: float) -> void:
	if is_moving:
		move_towards_target(delta)
	else:
		if player and can_see_player():
			MOVE_DURATION = NORMAL_MOVE_DURATION
			chase_player()
		else:
			MOVE_DURATION = WANDER_MOVE_DURATION
			random_walk()

func can_see_player() -> bool:
	var ray := PhysicsRayQueryParameters2D.new()
	ray.from = global_position
	ray.to = player.global_position
	ray.exclude = [self]
	ray.collision_mask = COLLISION_MASK
	var hit = get_world_2d().direct_space_state.intersect_ray(ray)
	return hit.is_empty()

func chase_player() -> void:
	var diff := player.global_position - global_position
	if abs(diff.x) > abs(diff.y):
		move_dir = Vector2.RIGHT if diff.x > 0 else Vector2.LEFT
	else:
		move_dir = Vector2.DOWN if diff.y > 0 else Vector2.UP
	try_start_move(move_dir)

func random_walk() -> void:
	if randi() % 20 != 0:
		return
	var dirs = [Vector2.RIGHT, Vector2.LEFT, Vector2.UP, Vector2.DOWN]
	move_dir = dirs.pick_random()
	try_start_move(move_dir)

func try_start_move(dir: Vector2) -> void:
	var new_position = global_position + dir * TILE_SIZE
	var ray := PhysicsRayQueryParameters2D.new()
	ray.from = global_position
	ray.to = new_position
	ray.exclude = [self]
	ray.collision_mask = COLLISION_MASK
	var collision = get_world_2d().direct_space_state.intersect_ray(ray)
	if collision.is_empty():
		start_position = global_position
		target_position = new_position
		move_timer = 0.0
		is_moving = true
		play_walk_animation(dir)

func move_towards_target(delta: float) -> void:
	move_timer += delta
	var t := move_timer / MOVE_DURATION
	t = min(t, 1.0)
	global_position = start_position.lerp(target_position, t)
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
