extends Area2D

func _ready():
	connect("body_exited", self, "_on_body_existed")
	

func _on_body_existed(body: Node2D):
	body.queue_free()
