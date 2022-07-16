extends RigidBody2D

onready var joint := $CollisionShape2D/PinJoint2D

func attach_body(body: PhysicsBody2D):
	joint.node_b = joint.get_path_to(body)
