class_name Cave extends TileMap

signal generated(last_ground)

export var vine_scene: PackedScene

export var torch_scene: PackedScene
export var torch_height := 76
export var torch_modulo := 50

export var generate_distance := 50
export var platform_height := 6

export var gap_size := 30

onready var platform_tile = tile_set.find_tile_by_name("platform")
onready var wall_tile = tile_set.find_tile_by_name("wall")

enum {
	PLATFORM
}

var logger = Logger.new("Cave")

var last_ceiling_block: Vector2
var last_ground_block: Vector2
var light_on = false
var gap_percentage = 0.5

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
	_fill_background(previous_last_ceiling, last_ground_block)
	
	emit_signal("generated", map_to_world(last_ground_block))

func _build_platform():
	logger.debug("Building PLATFORM for the next %s tiles" % generate_distance)
	
	var create_gap = randf() <= gap_percentage
	var gap_x = -1
	
	if create_gap:
		gap_x = randi() % (generate_distance - 5)
	
	var max_gap_x = gap_x + gap_size
	
	for x in range(1, generate_distance + 1):
		var is_in_gap_position = gap_x != -1 and x >= gap_x and x <= max_gap_x
#
		if is_in_gap_position:
			continue
			
		for y in range(0, platform_height):
			var pos = last_ground_block + Vector2(x, y)
			_set_ground(pos)
			
		for y in range(0, platform_height):
			var pos = last_ceiling_block + Vector2(x, -y)
			_set_ground(pos)
			
	
#	if gap_x != -1:
#		var vine = vine_scene.instance()
#		add_child(vine)
#		var tile_pos = last_ceiling_block + Vector2(gap_x, 0) + Vector2.DOWN 
#		vine.global_position = map_to_world(tile_pos)
#		logger.debug("Spawning vine at %s" % tile_pos)

func _set_ground(pos: Vector2):
	set_cellv(pos, platform_tile)
	update_bitmask_area(pos)


func _fill_background(top_left: Vector2, bottom_right: Vector2):
	for x in range(top_left.x, bottom_right.x + 1):
		if x % torch_modulo == 0:
			var world_x = map_to_world(Vector2(x, 0)).x
			var torch = torch_scene.instance()
			add_child(torch)
			torch.global_position = Vector2(world_x, torch_height)
			torch.turn_on(light_on)
		
		for y in range(top_left.y - platform_height, bottom_right.y + 1 + platform_height):
			if get_cell(x, y) == INVALID_CELL:
				set_cell(x, y, wall_tile)


func set_torch_level(level: int):
	light_on = level != 0
	for torch in get_children():
		if torch is Torch:
			torch.turn_on(light_on)
