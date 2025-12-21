extends Node2D

@export var reveal_radius_tiles := 3
var fog_layer: TileMapLayer

func _ready():
	fog_layer = get_parent().get_parent().get_node_or_null("Dungeon/FogLayer")

	if not fog_layer:
		push_error("FogLayer not found")

func _process(_delta):
	if fog_layer:
		reveal_fog()

func reveal_fog():
	# Convert world → fog local → tile
	var local_pos := fog_layer.to_local(global_position)
	var tile_pos := fog_layer.local_to_map(local_pos)
	for x in range(-reveal_radius_tiles, reveal_radius_tiles + 1):
		for y in range(-reveal_radius_tiles, reveal_radius_tiles + 1):
			var offset := Vector2i(x, y)
			if offset.length() > reveal_radius_tiles:
				continue
			fog_layer.erase_cell(tile_pos + offset)
