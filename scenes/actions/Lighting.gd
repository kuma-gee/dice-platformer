extends Node

export var cave_path: NodePath
onready var cave: Cave = get_node(cave_path)

export var global_light_path: NodePath
onready var global_light: Light2D = get_node(global_light_path)

export var player_light_path: NodePath
onready var player_light: Light2D = get_node(player_light_path)


var logger = Logger.new("Lighting")

const MIN_LEVEL = 1
const MAX_LEVEL = 4
var level = 4 setget _set_level

func _ready():
	self.level = 4

func _set_level(lvl: int):
	level = clamp(lvl, MIN_LEVEL, MAX_LEVEL)
	logger.info("Setting lighting level to %s" % level)
	_update_lighting()

func buff():
	self.level += 1
	
func debuff():
	self.level -= 1

func _update_lighting():
	match level:
		1: 
			cave.set_torch_level(0)
			global_light.energy = 0
			player_light.energy = 1
		2:
			cave.set_torch_level(1)
			global_light.energy = 0
			player_light.energy = 1
		3: 
			cave.set_torch_level(1)
			global_light.energy = 0.5
			player_light.energy = 1
		4:
			cave.set_torch_level(1)
			global_light.energy = 1
			player_light.energy = 0.5
