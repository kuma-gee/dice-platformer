extends KinematicBody2D

export var speed := 300

var dir = Vector2.LEFT

func _physics_process(delta):
	move_and_slide(dir * speed)
