extends KinematicBody2D

signal rolled(num)
signal died()

export var speed := 300
export var acceleration := 200
export var deacceleration := 400

export var jump_force := 1000
export var initial_gravity_force := 100
export var terminal_velocity_y := 300
export var jump_soft_cap := 100

export var rotation_speed := 800
export var rotation_landing_speed := 10000

export var landing_particles_scene: PackedScene

onready var input: PlayerInput = $PlayerInput
onready var sprite: Sprite = $Sprite

onready var ground_position := $GroundPosition
onready var jump_sound := $JumpSound

var logger = Logger.new("Dice")
var gravity_dir := Vector2.DOWN
var velocity := Vector2.ZERO
var fully_grounded = false
var random = RandomNumberGenerator.new()

func _ready():
	random.randomize()

func _process(delta):
	if not is_on_floor():
		var dir = sign(velocity.x) if abs(velocity.x) >= 0.01 else 1
		sprite.rotation_degrees += dir * rotation_speed * delta
		fully_grounded = false
	else:
		var diff_to_fully_grounded = int(sprite.rotation_degrees) % 90
		var was_fully_grounded = fully_grounded
		fully_grounded = diff_to_fully_grounded == 0
		
		if not fully_grounded:
			_rotate_to_ground(diff_to_fully_grounded, delta)
		elif not was_fully_grounded:
			_roll_random_number()
			var particles = landing_particles_scene.instance()
			particles.global_position = ground_position.global_position
			get_tree().current_scene.add_child(particles)

func _rotate_to_ground(diff: int, delta: float):
	var target_rotation = sprite.rotation_degrees - diff
	sprite.rotation_degrees = target_rotation
	

func _roll_random_number():
	var random_num = random.randi_range(1, 6)
	logger.info("Rolled %s" % random_num)
	
	_set_dice_num(random_num)
	emit_signal("rolled", random_num)

func _set_dice_num(num):
	sprite.frame = num if num > 0 else 0

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
		jump_sound.play()


func _on_PlayerInput_just_released(action):
	if action == "jump" and not fully_grounded:
		if velocity.y < -jump_soft_cap:
			logger.debug("Soft capping jump at %s" % velocity.y)
			velocity.y = -jump_soft_cap


func _on_HurtBox_hit():
	logger.info("Player died")
	emit_signal("died")

func disable_collision():
	$CollisionShape2D.disabled = true
