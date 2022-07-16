extends Node

onready var cave: Cave = $Cave
onready var generate_notifier := $Cave/GenerateNotifier

onready var low_actions := $LowAction
onready var medium_actions := $MediumAction
onready var high_actions := $HighAction


func _ready():
	randomize()

func _on_Dice_rolled(num):
	match num:
		3: _run_random_action(low_actions, false)
		4: _run_random_action(low_actions, true)
		
		2: _run_random_action(medium_actions, false)
		5: _run_random_action(medium_actions, true)
		
		1: _run_random_action(high_actions, false)
		6: _run_random_action(high_actions, true)

func _run_random_action(action: Node, buff: bool):
	var child = _random_child(action)
	if buff:
		child.buff()
	else:
		child.debuff()

func _random_child(node: Node):
	var child_idx = randi() % node.get_child_count()
	return node.get_child(child_idx)


func _on_GenerateNotifier_screen_entered():
	cave.build_next_tiles(Cave.PLATFORM)


func _on_Cave_generated(last_ground: Vector2):
	generate_notifier.global_position.x = last_ground.x - 100
