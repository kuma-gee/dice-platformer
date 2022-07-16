class_name Torch extends Node2D

onready var light := $Light2D

func turn_on(on: bool):
	light.visible = on
