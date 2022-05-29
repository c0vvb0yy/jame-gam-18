extends KinematicBody2D

export var speed : int = 100
export var jump_strength :int  = 300
export var max_jumps : int = 2
export var gravity : int = 50
export var max_slide_force : int = 600

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
var direction = Vector2.ZERO
var slide_decay = 15

var jump_next = false
var jump_count = 0

onready var sprite = $Sprite
# Called when the node enters the scene tree for the first time.


func _input(event: InputEvent) -> void:
#	if event.is_action_released("move_crouch"):
#		is_sliding = false
#		slide_force = 0
	
	if event.is_action("move_right"):
		input = 1
	elif event.is_action_released("move_left"):
		input = 0
	if event.is_action("move_left"):
		input = -1
	elif event.is_action_released("move_right"):
		input = 0
	
	if event.is_action_pressed("move_jump"):
		jump_next = true


func _physics_process(delta):
	apply_gravity()
	
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
	
	if jump_next:
		#print("jumping")
		if jump_count < max_jumps:
			jump_count += 1
			velocity.y = -jump_strength
			velocity.x *= 1.5
		jump_next = false
	
	if is_on_floor():
		jump_count = 0
#	if is_jumping:
#		jumps_made += 1
#		velocity.y = -jump_strength
#		velocity.x *= 1.5
#		if velocity.x >= 0:
#			velocity.x += 40
#		else:
#			velocity.x -= 40
#	if is_double_jumping && jumps_made <= max_jumps:
#		jumps_made += 1
#		velocity.y = -jump_strength
	if is_jump_cancelled:
		velocity.y = 0
	if is_crouching:
		sprite.set_flip_v(true)
	
	
	velocity = move_and_slide(velocity * delta * speed, Vector2.UP)
#	print(is_sliding)
#	print(slide_force)


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
