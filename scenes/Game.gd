extends Node

onready var cave: Cave = $Cave
onready var generate_notifier := $Cave/GenerateNotifier

func _ready():
	randomize()

func _on_Dice_rolled(num):
	pass # Replace with function body.


func _on_GenerateNotifier_screen_entered():
	cave.build_next_tiles(Cave.PLATFORM)


func _on_Cave_generated(last_ground: Vector2):
	generate_notifier.global_position.x = last_ground.x
