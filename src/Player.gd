extends Node2D
class_name Player


signal kill_player

onready var victory_container = $PlayerMovement/Camera2D/VictoryContainer
onready var body = $PlayerMovement
onready var vis_effect = $VHSEffect
onready var death_explosion = $PlayerMovement/DeathExplosion
var spawn_pos : Vector2

func _ready():
	vis_effect.visible = true

func set_victory_container_visible(visibility: bool):
	victory_container.visible = visibility


func disable_movement():
	body.set_process(false)
	body.set_physics_process(false)
	body.set_process_input(false)
	body.input = 0

func enable_movement():
	body.set_process(true)
	body.set_physics_process(true)
	body.set_process_input(true)

func play_anim():
	death_explosion.frame = 0
	death_explosion.play("default")

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
	enable_movement()
#	reset_explosion()

