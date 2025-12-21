extends Node2D
class_name Dungeon

@export var walk_length: int = 400
@export var start_position: Vector2i = Vector2i.ZERO

@onready var floor_layer: TileMapLayer = $FloorLayer
@onready var wall_layer: TileMapLayer = $WallLayer
@onready var walledge_layer: TileMapLayer = $WallEdgeLayer
@onready var fog_layer: TileMapLayer = $FogLayer

var floor_tiles := {}
var rng := RandomNumberGenerator.new()
var exit := Vector2i.ZERO

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
	exit = current_pos

	draw_tiles()
	generate_walls()

#Floor Tile ID is a constant, as there is only one TileSet used for the floor/walls
const FLOOR_TILE_ID := 0
#always uses the same tile (first tile, the grass)
const FLOOR_ATLAS_COORDS := Vector2i(0,0)

func draw_tiles() -> void:
	floor_layer.clear()
	for pos in floor_tiles.keys():
		floor_layer.set_cell(
			pos, 
			FLOOR_TILE_ID, 
			FLOOR_ATLAS_COORDS
		)

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

#Wall Tile ID is a constant, as there is only one TileSet used for the floor/walls
const WALL_TILE_ID := 0
#always uses the same tile (second tile, the stonebrick wall)
const WALL_ATLAS_COORDS := Vector2i(1,0)

#WallEdge Tile ID is not a constant, as I want to choose between three options
var WALLEDGE_TILE_ID := 0
#WallEdge uses the bitVal to determine which tile in the tilemap to use
const WALLEDGE_ATLAS_COORDS := {
	1: Vector2i(1,0),
	2: Vector2i(2,0),
	3: Vector2i(3,0),
	4: Vector2i(0,1),
	5: Vector2i(1,1),
	6: Vector2i(2,1),
	7: Vector2i(3,1),
	8: Vector2i(0,2),
	9: Vector2i(1,2),
	10: Vector2i(2,2),
	11: Vector2i(3,2),
	12: Vector2i(0,3),
	13: Vector2i(1,3),
	14: Vector2i(2,3),
	15: Vector2i(3,3)
}

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
	generate_walledges()

func generate_walledges() -> void:
	walledge_layer.clear()
	WALLEDGE_TILE_ID = randi_range(0,2) #which tilemap? 0 is stone, 1 is darkstone, 2 is gold
	var bitVal: int = 0;
	var used_cells: Array[Vector2i] = wall_layer.get_used_cells()
	for cell: Vector2i in used_cells:
		bitVal = 0
		for dir: Vector2i in wall_directions:
			var neighbour: Vector2i = cell + dir
			if wall_layer.get_cell_source_id(neighbour)  == -1 and dir == Vector2i.UP: bitVal += 1
			if wall_layer.get_cell_source_id(neighbour)  == -1 and dir == Vector2i.RIGHT: bitVal += 2
			if wall_layer.get_cell_source_id(neighbour)  == -1 and dir == Vector2i.DOWN: bitVal += 4
			if wall_layer.get_cell_source_id(neighbour)  == -1 and dir == Vector2i.LEFT: bitVal += 8
			if bitVal >0:
				walledge_layer.set_cell(
					cell,
					WALLEDGE_TILE_ID,
					WALLEDGE_ATLAS_COORDS[bitVal]
				)
	place_exit()

var exit_scene: PackedScene = preload("res://prefab/exit_door.tscn")
func place_exit() -> void:
	var exitdoor := exit_scene.instantiate()
	exitdoor.global_position = exit * 32
	add_child(exitdoor)
	walledge_layer.set_cell(
		exit,
		3, #the layer containing the door sprite
		Vector2i(0,1) #the open door
	)
	set_fog()

func set_fog() -> void:
	var used_rect: Rect2i = wall_layer.get_used_rect()
	for y in range(used_rect.position.y -1, used_rect.position.y + used_rect.size.y +1):
		for x in range(used_rect.position.x -1, used_rect.position.x + used_rect.size.x +1):
			var cell := Vector2i(x, y)
			fog_layer.set_cell(
				cell,
				0, #the only tile layer
				Vector2i(1,1) #the fog sprite
			)
