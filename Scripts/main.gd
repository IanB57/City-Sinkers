extends Node2D


var tilemap
var player
var TNT

var map_width := 36
var map_height := 22

var resources = 10;

var last_input

#breaks foreground tiles
func mine_tile(tile:Vector2i):
	if (tilemap.get_cell_atlas_coords(1, tile) == Tiles.DIRT):
		tilemap.set_cell(1, tile, 0, Tiles.EMPTY, -1)
		resources += 0.1

func place_tile(tile:Vector2i):
	if (tilemap.get_cell_atlas_coords(1, tile) == Tiles.EMPTY):
		tilemap.set_cell(1, tile, 0, Tiles.DIRT, 0)

func explode_at(tile:Vector2i):
	var surrounding_tiles = tilemap.get_surrounding_cells(tile)
	if (tilemap.get_cell_atlas_coords(1, tile) == Tiles.DIRT):
		tilemap.set_cell(1, tile, 0, Tiles.EMPTY, -1)
	for t in surrounding_tiles:
		var s_tiles2 = tilemap.get_surrounding_cells(t)
		for t2 in s_tiles2:
			if (tilemap.get_cell_atlas_coords(1, t2) == Tiles.DIRT):
				tilemap.set_cell(1, t2, 0, Tiles.EMPTY, -1)
		if (tilemap.get_cell_atlas_coords(1, t) == Tiles.DIRT):
				tilemap.set_cell(1, t, 0, Tiles.EMPTY, -1)
	

# Called when the node enters the scene tree for the first time.
func _ready():
	
	
	player = get_node("Player")
	tilemap = get_node("TileMap")
	TNT = get_node("TNT")
	
	TNT.set_position(tilemap.map_to_local(Vector2i(5, 7)))
	player.set_position(tilemap.map_to_local(Vector2i(6,6)))
	
	for w in range(map_width):
		for h in range(map_height):
			#		set_cell(layer, cell_coord, source_id (0), Tile, alt tile (0))
			tilemap.set_cell(0, Vector2i(w, h), 0, Tiles.BACKGROUND_DIRT, 0) #background blocks
			tilemap.set_cell(1, Vector2i(w, h), 0, Tiles.DIRT, 0) #foreground blocks
	for w in range(4, 8):
		for h in range(4, 8):
			tilemap.set_cell(1, Vector2i(w,h), 0, Tiles.EMPTY, -1) #starting area (air blocks)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var tile_to_mine = -1; #check CellNeighbor Enum on https://docs.godotengine.org/en/stable/classes/class_tileset.html#enum-tileset-cellneighbor
	var mousePosition = tilemap.local_to_map(get_global_mouse_position())
	var playerPosition = tilemap.local_to_map(player.get_position())
	
	if(Input.is_action_pressed("mine")):
		print("mine")
		
	if (Input.is_action_pressed("move_right") && Input.is_action_pressed("mine")):
		tile_to_mine = 0;
#		print("success")
	
#	if (Input.is_action_just_pressed("mine")):
#		if(last_input < 0):
#			tile_to_mine = 8
#		else:
#			tile_to_mine = 0
		#figure out what data type "direction" is because that's what you set last_input to, then somehow get last_input to dictate which block gets
		#mined WITHIN this funciton. Then figure out why godot doesn't take mouse click input after keyboard input
		#but does take keyboard input simultaneously (you set M to mine).
#	
	if (Input.is_action_pressed("mine") && Input.is_action_pressed("move_left")):
		tile_to_mine = 8;
	if (Input.is_action_pressed("mine") && Input.is_action_pressed("jump")):
		tile_to_mine = 12;
	if (Input.is_action_pressed("mine") && Input.is_action_pressed("move_down")):
		tile_to_mine = 4;

	if (tile_to_mine > -1):
		var tile = tilemap.get_neighbor_cell(tilemap.local_to_map(player.get("position")), tile_to_mine)
		mine_tile(tile)
	
	if (Input.is_action_just_pressed("explode")):
		var tile = tilemap.local_to_map(get_global_mouse_position())
		explode_at(tile)
		
	if (Input.is_action_just_pressed("place_block") && resources >= 1):
		resources = resources - 1
		if ((mousePosition - playerPosition).length_squared()) == 1:
			place_tile(mousePosition)

#	print(tilemap.local_to_map(get_global_mouse_position()))
#	print(tilemap.local_to_map(player.get_position()))
#	print(tilemap.local_to_map(get_global_mouse_position()) - tilemap.local_to_map(player.get_position()))
#	print((mousePosition - playerPosition).length_squared())
	
	
		
		
