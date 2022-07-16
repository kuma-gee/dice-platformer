extends KinematicBody2D

export var speed := 100
export var rotation_speed := 100

var dir = Vector2.LEFT

func _physics_process(delta):
	rotation_degrees -= rotation_speed * delta
	
	var velocity = dir * speed
	velocity += Vector2.DOWN * 100
	move_and_slide(velocity)
