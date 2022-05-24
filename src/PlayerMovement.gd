extends KinematicBody2D

export var speed : int
export var jump_strength :int 
export var max_jumps : int
export var gravity : int

var jumps_made = 0;
var velocity = Vector2.ZERO;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	var horizontal_direction = (
		Input.get_action_strength("move_right") 
		- Input.get_action_strength("move_left")
	)
	velocity.x = horizontal_direction * speed
	velocity.y += gravity * delta
	
	velocity = move_and_slide(velocity, Vector2.UP)
	
