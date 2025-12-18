extends Node2D

@export var walk_length: int = 400
@export var start_position: Vector2i = Vector2i.ZERO

@onready var floor_layer: TileMapLayer = $FloorLayer
@onready var wall_layer: TileMapLayer = $WallLayer

var floor_tiles := {}
var rng := RandomNumberGenerator.new()

var directions : Array[Vector2i] = [
	Vector2i.UP,
	Vector2i.DOWN,
	Vector2i.LEFT,
	Vector2i.RIGHT
]

func _ready() -> void:
	rng.randomize()
	generate_dungeon()

func generate_dungeon() -> void:
	floor_tiles.clear()

	var current_pos := start_position
	floor_tiles[current_pos] = true

	for i in walk_length:
		var dir := directions[rng.randi_range(0, directions.size() - 1)]
		var next_pos := current_pos + dir
		
		if not floor_tiles.has(next_pos):
			floor_tiles[next_pos] = true
			current_pos = next_pos
		#current_pos += dir
		#floor_tiles[current_pos] = true

	draw_tiles()
	generate_walls()

func draw_tiles() -> void:
	floor_layer.clear()

	for pos in floor_tiles.keys():
		floor_layer.set_cell(pos, 0, Vector2i.ZERO)

var wall_directions: Array[Vector2i] = [
	Vector2i.UP,
	Vector2i.DOWN,
	Vector2i.LEFT,
	Vector2i.RIGHT,
	Vector2i(-1,-1),
	Vector2i(1,-1),
	Vector2i(-1,1),
	Vector2i(1,1)
]

const WALL_TILE_ID := 0
const WALL_ATLAS_COORDS := Vector2i(1,0)

func generate_walls() -> void:
	wall_layer.clear()
	
	var used_cells: Array[Vector2i] = floor_layer.get_used_cells()

	for cell: Vector2i in used_cells:
		for dir: Vector2i in wall_directions:
			var neighbour: Vector2i = cell + dir

			if floor_layer.get_cell_source_id(neighbour) == -1 \
			and wall_layer.get_cell_source_id(neighbour) == -1:
				wall_layer.set_cell(
					neighbour,              # position
					WALL_TILE_ID,    # tileset source ID
					WALL_ATLAS_COORDS  # atlas coordinates
				)
