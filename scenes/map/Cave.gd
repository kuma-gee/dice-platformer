class_name Cave extends TileMap

signal generated(last_ground)

export var generate_distance := 50
export var platform_height := 6

onready var platform_tile = tile_set.find_tile_by_name("platform")
onready var wall_tile = tile_set.find_tile_by_name("wall")

enum {
	PLATFORM
}

var logger = Logger.new("Cave")

var last_ceiling_block: Vector2
var last_ground_block: Vector2

func _ready():
	_update_last_blocks()

func _update_last_blocks() -> void:
	var last_ground = Vector2.ZERO
	var last_ceiling = Vector2.ZERO
	
	for cell in get_used_cells():
		var is_platform = get_cellv(cell) == platform_tile
		if not is_platform: continue
		
		var is_ground = cell.y >= 0
		if is_ground:
			last_ground.x = max(last_ground.x, cell.x)
			last_ground.y = min(last_ground.y, cell.y) if last_ground.y != 0 else cell.y
		else:
			last_ceiling.x = max(last_ceiling.x, cell.x)
			last_ceiling.y = max(last_ceiling.y, cell.y) if last_ceiling.y != 0 else cell.y
	
	last_ceiling_block = last_ceiling
	last_ground_block = last_ground
	
	logger.debug("Update last ceiling block %s" % last_ceiling_block)
	logger.debug("Update last ground block %s" % last_ground_block)

func build_next_tiles(type: int):
	if type == PLATFORM:
		_build_platform()
	
	var previous_last_ceiling = last_ceiling_block
	_update_last_blocks()
	_fill_with_wall(previous_last_ceiling, last_ground_block)
	
	emit_signal("generated", map_to_world(last_ground_block))

func _build_platform():
	logger.debug("Building PLATFORM for the next %s tiles" % generate_distance)
	
	for x in range(1, generate_distance + 1):
		for y in range(0, platform_height):
			logger.debug("Pos %s/%s" % [x, y])
			var pos = last_ground_block + Vector2(x, y)
			_set_ground(pos)
		
		for y in range(0, platform_height):
			var pos = last_ceiling_block + Vector2(x, -y)
			_set_ground(pos)


func _set_ground(pos: Vector2):
	set_cellv(pos, platform_tile)
	update_bitmask_area(pos)


func _fill_with_wall(top_left: Vector2, bottom_right: Vector2):
	for x in range(top_left.x, bottom_right.x + 1):
		for y in range(top_left.y, bottom_right.y + 1):
			if get_cell(x, y) == INVALID_CELL:
				set_cell(x, y, wall_tile)
