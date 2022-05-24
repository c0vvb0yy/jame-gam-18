extends KinematicBody2D

export var speed : int
export var jump_strength :int 
export var max_jumps : int
export var gravity : int
export var max_slide_force : int

var jumps_made = 0;
var slide_force = 0;
var velocity = Vector2.ZERO;

#move state vars
var is_falling : bool
var is_jumping : bool
var is_double_jumping : bool
var is_jump_cancelled : bool
var is_running : bool
var is_crouching : bool
var is_sliding : bool
var is_idling : bool

var input = 0
var slide_decay = 15

onready var sprite = $Sprite
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	apply_gravity()
	if Input.is_action_just_pressed("move_right"):
		input = 1
	if Input.is_action_just_pressed("move_left"):
		input = -1
	if Input.is_action_just_released("move_right") || Input.is_action_just_released("move_left"):
		input = 0
	if is_sliding:
		if(input == 1):
			slide_force = max_slide_force
		else:
			slide_force = -max_slide_force
		input = 0
	if slide_force > 0:
		slide_force -= slide_decay
		if slide_force <= 0:
			velocity.x = 0
	elif slide_force < 0:
		slide_force += slide_decay
		if slide_force >= 0:
			velocity.x = 0
	
	velocity.x = input * speed + slide_force
	velocity.y += gravity * delta
	
	get_move_state()
	if is_idling:
		jumps_made = 0;
		if(sprite.is_flipped_v()):
			sprite.set_flip_v(false)
	
	if is_jumping:
		jumps_made += 1
		velocity.y = -jump_strength
	if is_double_jumping && jumps_made <= max_jumps:
		jumps_made += 1
		velocity.y = -jump_strength
	if is_jump_cancelled:
		velocity.y = 0
	if is_crouching:
		sprite.set_flip_v(true)
	
	velocity = move_and_slide(velocity, Vector2.UP)
	print(is_sliding)
	print(slide_force)

func get_move_state():
	is_falling = velocity.y > 0.0 && !is_on_floor()
	is_jumping = Input.is_action_just_pressed("move_jump") && is_on_floor()
	is_double_jumping = Input.is_action_just_pressed("move_jump") && !is_on_floor()
	is_jump_cancelled = Input.is_action_just_released("move_jump") && velocity.y < 0.0
	is_running = is_on_floor() && velocity.x > 1
	is_crouching = Input.is_action_pressed("move_crouch")
	is_sliding = Input.is_action_just_pressed("move_crouch") && !is_zero_approx(velocity.x)
	is_idling = is_on_floor() && velocity.x < 1 && !is_crouching

func apply_gravity() -> void:
	# faster acceleration at start of fall with upper limit
	if velocity.y < 100:
		velocity.y += gravity * 5
	elif velocity.y < 250:
		velocity.y += gravity * 2
	elif velocity.y < 500:
		velocity.y += gravity * 1.5
	elif velocity.y > 2000:
		velocity.y = 2000
	else:
		velocity.y += gravity
