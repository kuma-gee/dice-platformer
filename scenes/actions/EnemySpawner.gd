extends Timer

export var max_delay := 5.0
export var min_delay := 0.5
export var delay_step := 0.5

export var air_enemy_scene: PackedScene
export var air_spawn_point_path: NodePath
onready var air_spawn_point: Position2D = get_node(air_spawn_point_path)

export var ground_enemy_scene: PackedScene
export var ground_spawn_point_path: NodePath
onready var ground_spawn_point: Position2D = get_node(ground_spawn_point_path)

var logger = Logger.new("EnemySpawner")
var delay := 5.0 setget _set_delay

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("timeout", self, "_on_timeout")

func _set_delay(value: float):
	delay = clamp(value, min_delay, max_delay)
	logger.info("Changing spawn delay to %s" % delay)

func _on_timeout():
	_spawn_random()
	start(delay)

func _spawn_random():
	var type = randi() % 2
	if type <= 0:
		logger.info("Spawning air enemy")
		_spawn_scene_at(air_enemy_scene, air_spawn_point.global_position)
	else:
		logger.info("Spawning ground enemy")
		_spawn_scene_at(ground_enemy_scene, ground_spawn_point.global_position)
	
func _spawn_scene_at(scene: PackedScene, pos: Vector2):
	var enemy = scene.instance()
	get_tree().current_scene.add_child(enemy)
	enemy.global_position = pos

func buff():
	self.delay += delay_step

func debuff():
	self.delay -= delay_step
