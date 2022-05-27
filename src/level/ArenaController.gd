extends Node2D



var current_player = null
var current_arena = null

var player = preload("res://src/Player.tscn")

func _ready() -> void:
	load_arena(GameData.next_arena)

func get_player_ref():
	var players =  get_tree().get_nodes_in_group("Player")
	if players.size() > 0:
		current_player = players[0]
		# assign the first player we find to the referencee
		# depending on how we implement the replay, this may have to be refactored
	else:
		var new_player = player.instance()
		current_player = new_player

func load_arena(arena_index: int):
	# trash all other arenas here
	for c in get_children():
		if c.has_method("player_spawn_point_global_coords"):
			c.queue_free()
			
	for ping in get_tree().get_nodes_in_group("PlayerPing"):
		ping.queue_free()
	
	#var file_path = str("res://src/level/arenas/arena", arena_index, ".tscn")
	# get file path
	var file_path = ""
	if arena_index < GameData.ARENA_ORDER.size():
		file_path = GameData.ARENA_ORDER[arena_index]
	# check if that level exists
	var file_to_check = File.new()
	var file_exists = file_to_check.file_exists(file_path)
	if file_exists:
		# remove all previous arenas
		for c in get_children():
			if c.is_in_group("Arena"):
				c.queue_free()
		
		# instance the new arena
		var arena_res = load(file_path)
		var new_arena = arena_res.instance()
		add_child(new_arena)
		current_arena = new_arena
		
		# place player there
		get_player_ref()
		add_child(current_player)
		position_player_at_spawn()
		# idk create the starting state of the player


func position_player_at_spawn():
	if current_arena != null:
		# get the spawn position
		var spawn_pos = current_arena.player_spawn_point_global_coords()
		current_player.global_position = spawn_pos

func show_victory_screen():
	print("you won")

func end_run():
	position_player_at_spawn()
	pass
	# stop recording
	# reset player position
	# play all recordings
	print("ctr got player kill")
	

func play_recordings():
	pass
	# play all recordings

func start_run():
	pass
	# start timer


