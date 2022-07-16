class_name PlayerCamera extends Camera2D

export var speed := 10

export var player_path: NodePath
onready var player: Node2D = get_node(player_path)

func _process(delta):
	var player_x = player.global_position.x
	
	if player_x > global_position.x:
		global_position.x = player_x
	else:
		global_position.x += speed * delta
