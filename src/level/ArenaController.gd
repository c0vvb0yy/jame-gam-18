extends Node2D

var player = null

func _ready() -> void:
	load_arena(GameData.next_arena)

func get_player_ref():
	var players =  get_tree().get_nodes_in_group("Player")
	if players.size() > 0:
		player = players[0]
		# assign the first player we find to the referencee
		# depending on how we implement the replay, this may have to be refactored
	else:
		pass
		# instance a new player

func load_arena(arena_index: int):
	var file_path = str("res://src/level/arenas/arena", arena_index, ".tscn")
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
		
		# place player there
		var spawn_pos = new_arena.player_spawn_point_global_coords()
		player.global_position = spawn_pos
		# idk create the starting state of the player
