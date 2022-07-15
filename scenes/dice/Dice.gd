extends KinematicBody2D

signal rolled(num)

export var speed := 300
export var acceleration := 200
export var deacceleration := 400

export var jump_force := 1000
export var initial_gravity_force := 100
export var terminal_velocity_y := 300
export var jump_soft_cap := 100

export var rotation_speed := 800
export var rotation_landing_speed := 10

onready var input: PlayerInput = $PlayerInput

var logger = Logger.new("Dice")
var gravity_dir := Vector2.DOWN
var velocity := Vector2.ZERO
var fully_grounded = false

# Should be the safety measure to make sure you will always be grounded
var trying_to_ground = false

func _process(delta):
	if not is_on_floor() and not trying_to_ground:
		rotation_degrees += rotation_speed * delta
		fully_grounded = false
	else:
		var diff_to_fully_grounded = int(rotation_degrees) % 90
		var was_fully_grounded = fully_grounded
		fully_grounded = diff_to_fully_grounded == 0
		
		if not fully_grounded:
			trying_to_ground = true
			_rotate_to_ground(diff_to_fully_grounded, delta)
		elif not was_fully_grounded:
			_roll_random_number()
			trying_to_ground = false

func _rotate_to_ground(diff: int, delta: float):
	var target_rotation = rotation_degrees - diff
	var needed_rotation_abs = abs(diff)

	rotation_degrees = move_toward(rotation_degrees, target_rotation, rotation_landing_speed * needed_rotation_abs * delta)

func _roll_random_number():
	var random_num = randi() % 6 + 1
	logger.info("Rolled %s" % random_num)
	emit_signal("rolled", random_num)


func _physics_process(delta):
	var dir = _get_motion()
	
	var is_moving = dir.length() > 0.01
	var speed_change = acceleration if is_moving else deacceleration
	
	velocity = velocity.move_toward(dir * speed, speed_change * delta)
	
	velocity += gravity_dir * initial_gravity_force
	if velocity.y >= terminal_velocity_y:
		velocity.y = terminal_velocity_y
	
	velocity = move_and_slide(velocity, Vector2.UP)

func _get_motion() -> Vector2:
	return Vector2(input.get_action_strength("move_right") - input.get_action_strength("move_left"), 0)


func _on_PlayerInput_just_pressed(action):
	if action == "jump" and fully_grounded:
		velocity -= gravity_dir * jump_force


func _on_PlayerInput_just_released(action):
	if action == "jump" and not fully_grounded:
		if velocity.y < -jump_soft_cap:
			logger.debug("Soft capping jump at %s" % velocity.y)
			velocity.y = -jump_soft_cap
