extends KinematicBody2D

export var speed : int = 400
export var jump_strength :int  = 750
export var max_jumps : int = 2
export var gravity : int = 2500
export var max_slide_force : int = 600
export var jump_impulse_x = 140
export var ground_slam_impuse_y = 1500
export var grappling_pull = 133
export var mid_air_control = 30
export var max_pings = 2

export var upgrade_jumps = 1
export var upgrade_illumination_scale = 0.5
export var upgrade_grappling_pull = 133
export var upgrade_pings = 1

var jumps_made = 0
var slide_force = 0
var velocity = Vector2.ZERO
var chain_velocity = Vector2.ZERO
var run_pings = 0
var all_pings = 0

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

onready var sprite = $Sprite
onready var eye_counter = $Camera2D/CenterContainer/HBoxContainer/EyeCounter
onready var sfx_player = $AudioStreamPlayer
onready var player_illumination = $PlayerIllumination

var last_collision

var grappling_hook

var player_ping = preload("res://src/PlayerPing.tscn")
var recorded_player = preload("res://src/RecordedPlayer.tscn")

#replay vars
var replay = [] #array of dicts that store button input press, begging and end
var memory = {"L":0, "R":0, "J":0, "C":0, "H":[0,0], "P": 0} #dictionary to hold input and when pressed
var frames = 0
var replay_index = 0

var start_pos : Vector2

func _ready():
	if UpgradeData.has_upgrade(UpgradeData.Upgrades.HardGrapple):
		grappling_pull += upgrade_grappling_pull
	if UpgradeData.has_upgrade(UpgradeData.Upgrades.ThirdJump):
		max_jumps += upgrade_jumps
	if UpgradeData.has_upgrade(UpgradeData.Upgrades.ThirdEye):
		max_pings += upgrade_pings
	if UpgradeData.has_upgrade(UpgradeData.Upgrades.PingRange):
		player_illumination.scale += Vector2(upgrade_illumination_scale, upgrade_illumination_scale)
	
	frames = 0
	replay_index = 0
	start_pos = self.global_position
	eye_counter.text = str(max_pings)
	grappling_hook = $GrapplingHook
	


func _input(event: InputEvent) -> void:
	
	var left = false
	if event.is_action("move_left"):
		input = -1
		left = true
	elif event.is_action_released("move_right"):
		input = 0
	
	if event.is_action("move_right"):
		input = 1
		left = false
	elif event.is_action_released("move_left"):
		input = 0
	
	if event.is_action("move_left") && event.is_action("move_right"):
		input = 0
	

	if event.is_action_released("move_right"):
		input = 0 if !left else -1
	if event.is_action_released("move_left"):
		input = 1 if !left else 0
	
	if GameData.allow_grappling_hook:
		if event.is_action_pressed("grapple_shoot"):
			grappling_hook.shoot(get_global_mouse_position() - self.global_position )#+ get_viewport().size * 0.5)
#			if grappling_hook.is_hooked && memory.H == 0: #saving the first frame where the grappling hook is hooked
#				memory.H = [frames, grappling_hook.hook_pos] #saving the start frame of being hooked and the pos where to get pulled to
		elif event.is_action_released("grapple_shoot"):
			grappling_hook.release()
			#replay.append({"key":"H", "start_frame":self.memory.H[0], "end_frame": self.frames, "hook_pos": self.memory.H[1]})
	
	if GameData.allow_ping:
		if event.is_action_pressed("ping"):
			if run_pings < max_pings:
				var controllers = get_tree().get_nodes_in_group("ArenaController")
				if controllers.size() > 0:
					var controller = controllers[0]
					var new_ping = player_ping.instance()
					new_ping.global_position = global_position
					controller.add_child(new_ping)
				run_pings += 1
				all_pings += 1
				eye_counter.text = str(max_pings - run_pings)
	else:
		eye_counter.get_parent().visible = false

func _process(delta: float) -> void:
	update_player_sprite()

func get_pings_used_in_level() -> int:
	return all_pings

func _physics_process(delta):
	
	#save_input_for_replay()
	
	if is_sliding:
		slide_force = max_slide_force
		#input = 0
	slide_force -= slide_decay
	if slide_force <= 0:
		slide_force = 0
		#velocity.x = 0
	
	# fake slide force is the one we actually slap onto the velocity
	# slide force is the interal tracker var to handle decay
	var fake_side_force = slide_force
	if velocity.x > 0:
		fake_side_force *= 1.0
	else:
		fake_side_force *= -1.0
	
	if !is_on_floor():
		velocity.x = sign(velocity.x) * speed + fake_side_force
	else:
		velocity.x = input * speed + fake_side_force
	if fake_side_force != 0:
		# I forgot what the 50 does
		 velocity.y += gravity * delta + (50 * (1 / fake_side_force))
	else:
		velocity.y += gravity * delta
	
	get_move_state()
	
	
	if is_on_floor() || is_on_wall():
		jumps_made = 0
	
	if is_jumping:
		
		jump()
		
		if is_sliding:
			input = sign(velocity.x) * 1.0
			velocity *= 100 # ???
		
	if is_double_jumping && jumps_made < max_jumps:
		jump()
#	if is_jump_cancelled:
#		velocity.y = 0
	if is_crouching && !is_on_floor():
		#if input == 0:
			# ground slam
			velocity.y = ground_slam_impuse_y
			velocity.x = 0
			mid_air_control = 0
	
	chain_velocity = Vector2.ZERO
	if grappling_hook != null:
		if grappling_hook.is_hooked:
			chain_velocity = grappling_hook.hook.position.normalized() * -grappling_pull
			if chain_velocity.y > 0:
				#pulling down isnt as strong
				chain_velocity.y *= 0.55
			else:
				#pulling up is stronger
				chain_velocity.y *= 3.00
			if sign(chain_velocity.x) != sign(input):
				#if we are going in a different direction than the chain is pulling us
				# increase the pull so that we go towards the hook
				chain_velocity.x *= 1.5
		else:
			chain_velocity = Vector2.ZERO
	
	if chain_velocity != Vector2.ZERO:
		velocity = chain_velocity * -5
	
	# mid-air control
	if !is_on_floor():
		velocity.x += sign(input) * mid_air_control
		#velocity.x *= 0.5
	
	velocity = move_and_slide(Vector2(min(1500,velocity.x), min(1500, velocity.y)), Vector2.UP)
	
	# play sound whenever we collide with something
	var collision = move_and_collide(Vector2.ZERO)
	if collision && !last_collision:
		sfx_player.stream = load(AudioData.SFX_PATHS.get(AudioData.SFXKeys.PlayerSurfaceHit))
		sfx_player.volume_db = AudioData.db_level - 5
		sfx_player.play(0.0)
	last_collision = collision
	
	frames += 1


func jump():
	velocity.y = -jump_strength
	velocity.x = sign(input) * jump_impulse_x
	
	# more strength for when you jump mid air
	if is_double_jumping:
		velocity.x *= 2
	
	
	jumps_made += 1
	#print(str("jumps ", jumps_made, " / ", max_jumps))
	
	sfx_player.stream = load(AudioData.SFX_PATHS.get(AudioData.SFXKeys.PlayerJump))
	sfx_player.volume_db = AudioData.db_level
	sfx_player.play(0.0)
	

func update_player_sprite():
	sprite.scale.y = 1
	var orientation = sign(input)
	if orientation != sprite.scale.x && orientation != 0:
		sprite.scale.x = orientation
	
	if is_crouching && is_on_floor():
		sprite.rotation_degrees = orientation * -15
	else:
		sprite.rotation_degrees = 0

func get_move_state():
	is_falling = velocity.y > 0.0 && !is_on_floor()
	is_jumping = Input.is_action_just_pressed("move_jump") && is_on_floor()
	is_double_jumping = Input.is_action_just_pressed("move_jump") && !is_on_floor()
	is_jump_cancelled = Input.is_action_just_released("move_jump") && velocity.y < 0.0
	is_running = is_on_floor() && velocity.x > 1
	is_crouching = Input.is_action_pressed("move_crouch")
	is_sliding = Input.is_action_just_pressed("move_crouch") && !is_zero_approx(velocity.x)
	is_idling = is_on_floor() && velocity.x < 1 && !is_crouching || !is_sliding
	
	# go go gadget spaghetti code
	if Input.is_action_just_pressed("move_crouch") && is_on_floor():
		sfx_player.stream = load(AudioData.SFX_PATHS.get(AudioData.SFXKeys.PlayerSlideBegin))
		sfx_player.volume_db = AudioData.db_level - 2
		sfx_player.play(0.05)

func save_input_for_replay() -> void:
	#recodrind starting input
	if Input.is_action_just_pressed("move_left"): memory.L = frames
	if Input.is_action_just_pressed("move_right"): memory.R = frames
	if Input.is_action_just_pressed("move_jump"): memory.J = frames
	if Input.is_action_just_pressed("move_crouch"): memory.C = frames
	
	#recording end input
	#this is the actual array we will use for replays
	#grappling hook stuff is recorded in the input event function
	if Input.is_action_just_released("move_left"): replay.append({"key":"L", "start_frame":self.memory.L, "end_frame":self.frames})
	if Input.is_action_just_released("move_right"): replay.append({"key":"R", "start_frame":self.memory.L, "end_frame":self.frames})
	if Input.is_action_just_released("move_jump"): replay.append({"key":"J", "start_frame":self.memory.L, "end_frame":self.frames})
	if Input.is_action_just_released("move_crouch"): replay.append({"key":"C", "start_frame":self.memory.L, "end_frame":self.frames})
	if Input.is_action_just_released("ping"): replay.append({"key":"P", "start_frame":self.memory.P, "end_frame":self.frames})
	


func _on_Player_kill_player():
	run_pings = 0
