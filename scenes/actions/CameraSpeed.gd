extends Node

export var min_speed := 10
export var max_speed := 100
export var speed_diff := 20

export var camera_path: NodePath
onready var camera: PlayerCamera = get_node(camera_path)

var logger = Logger.new("CameraSpeed")

func buff():
	camera.speed = max(camera.speed - speed_diff, min_speed)
	logger.info("Set camera speed to %s" % camera.speed)


func debuff():
	camera.speed = min(camera.speed + speed_diff, max_speed)
	logger.info("Set camera speed to %s" % camera.speed)
