extends Node2D
class_name Player


signal kill_player

onready var victory_container = $PlayerMovement/Camera2D/VictoryContainer
onready var victory_screen = $PlayerMovement/Camera2D/VictoryScreen
onready var body = $PlayerMovement
onready var vis_effect = $PlayerMovement/Camera2D/VHSEffect
onready var death_explosion = $PlayerMovement/DeathExplosion
onready var clock = $PlayerMovement/Camera2D/Timer
onready var on_death_label = $PlayerMovement/Camera2D/RewindOnDeathLabel
var spawn_pos : Vector2

onready var sfx_player = $SFXPlayer

func _ready():
	vis_effect.visible = true

func _input(event):
	if event.is_action_pressed("reset"):
		kill_player()

func _process(delta):
	if on_death_label.visible && on_death_label.modulate.a != 1 :
		on_death_label.modulate.a += 0.02

func set_victory_container_visible(visibility: bool):
	victory_container.visible = visibility


func disable_movement():
	if body.grappling_hook.is_hooked:
		body.grappling_hook.release()
	body.set_process(false)
	body.set_physics_process(false)
	body.set_process_input(false)
	body.input = 0
	clock.set_process(false)


func enable_movement():
	body.set_process(true)
	body.set_physics_process(true)
	body.set_process_input(true)
	clock.set_process(true)
	on_death_label.visible = false

func play_anim():
	death_explosion.frame = 0
	death_explosion.play("default")
	body.sprite.visible = false
	on_death_label.visible = true
	on_death_label.modulate.a = 0

#func play_explosion():
#	death_explosion.visible = true
#	death_explosion.play("default")
#	print(death_explosion.get_instance_id())

#func reset_explosion():
#	death_explosion.frame = 0

func kill_player():
	# get the arena controller
	var controllers = get_tree().get_nodes_in_group("ArenaController")
	if controllers.size() > 0:
		var controller = controllers[0]
		
		# emit the signal that the player died
		connect("kill_player", controller, "end_run")
		emit_signal("kill_player")
		disconnect("kill_player", controller, "end_run")
	body.position = spawn_pos
	body.eye_counter.text = str(body.max_pings)
	enable_movement()
	clock.elapsed_time = 0
	body.sprite.visible = true
#	reset_explosion()

	# play sound
	sfx_player.stream = load(AudioData.SFX_PATHS.get(AudioData.SFXKeys.PlayerRewind))
	sfx_player.volume_db = AudioData.db_level
	sfx_player.play(0.2)

