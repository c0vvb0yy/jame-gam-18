extends Node2D

onready var chain = $Chain
onready var hook = $Hook
onready var sfx_player = $AudioStreamPlayer2D

var direction : Vector2  #direction in which the hook was shot
var hook_pos : Vector2  #end pos of the tip, global position 

export var speed : int = 89
export var upgrade_speed = 300

var is_flying = false #travelling
var is_hooked = false #connected to a wall or not

func _ready() -> void:
	if UpgradeData.has_upgrade(UpgradeData.Upgrades.HardGrapple):
		speed += upgrade_speed

func shoot(dir : Vector2) -> void:
	direction = dir.normalized()
	is_flying = true
	hook_pos = self.global_position #reset hook pos to player pos
	

func release() -> void:
	is_flying = false
	is_hooked = false
	sfx_player.stream = load(AudioData.SFX_PATHS.get(AudioData.SFXKeys.PlayerGrappleRelease))
	sfx_player.volume_db = AudioData.db_level - 3
	sfx_player.play(0.00)

#graphics update -> visuals
func _process(delta):
	self.visible = is_flying || is_hooked
	if !self.visible:
		return #dont gotta draw anythin
	var hook_location = to_local(hook_pos)
	#rotating the chain and the tip to fit on the line between origin (player.pos) and hook_pos
	chain.rotation = self.position.angle_to_point(hook_location) - deg2rad(90)
	hook.rotation = self.position.angle_to_point(hook_location) - deg2rad(90)
	chain.position = hook_location
	chain.region_rect.size.y = hook_location.length()

#physics update -> pos of hook
func _physics_process(delta):
	hook.global_position = hook_pos #player might have moved and thus updated the position of the tip -> resetting it
	if is_flying:
		if hook.move_and_collide(direction * speed): #returns true if collided with something
			is_hooked = true
			is_flying = false
			sfx_player.stream = load(AudioData.SFX_PATHS.get(AudioData.SFXKeys.PlayerGrappleHit))
			sfx_player.volume_db = AudioData.db_level
			sfx_player.play(0.0)
	hook_pos = hook.global_position #set hook as starting point for next frame
