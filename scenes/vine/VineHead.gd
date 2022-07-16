extends Node2D

export var vine_line_scene: PackedScene

export var min_vine_length := 3
export var max_vine_length := 6

onready var joint := $CollisionShape2D/PinJoint2D

var logger = Logger.new("VineHead")
var random = RandomNumberGenerator.new()

func _ready():
	random.randomize()
	
	var length = random.randi_range(min_vine_length, max_vine_length)
	logger.debug("Creating vine of length %s" % length)
	
#	var vine = vine_line_scene.instance()
#	add_child(vine)
#	vine.global_position = global_position
#
#	var joint = PinJoint2D.new()
#	add_child(joint)
#	joint.global_position = global_position
#
#	joint.node_a = joint.get_path_to(self)
#	joint.node_b = joint.get_path_to(vine)
	
#	get_tree().paused = true

	var current = self
	for i in range(0, length):
		var vine_line = vine_line_scene.instance()
		add_child(vine_line)
		vine_line.global_position = current.joint.global_position
		current.attach_body(vine_line)
		current = vine_line

func attach_body(body: RigidBody2D):
	joint.node_b = joint.get_path_to(body)
