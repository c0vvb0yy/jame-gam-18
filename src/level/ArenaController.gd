extends Node2D



var current_player = null
var current_arena = null

var player = preload("res://src/Player.tscn")


onready var music_player = $MusicPlayer
onready var sfx_player = $SFXPlayer

func _ready() -> void:
	load_arena(GameData.next_arena)

func _input(event):
	if event.is_action("return_to_menu"):
		get_tree().change_scene("res://src/menus/MainMenu.tscn")

func get_player_ref():
	var players =  get_tree().get_nodes_in_group("Player")
	if players.size() > 0:
		current_player = players[0]
		# assign the first player we find to the referencee
		# depending on how we implement the replay, this may have to be refactored
#	else:
#		var new_player = player.instance()
#		current_player = new_player

func load_arena(arena_index: int):
	# old arena still here
	
	
	
	for c in get_children():
		if c.has_method("player_spawn_point_global_coords"):
			# save playback pos of current arena
			AudioData.last_playback_position = music_player.get_playback_position()
			# trash all other arenas here
			c.queue_free()
			
	for ping in get_tree().get_nodes_in_group("PlayerPing"):
		ping.queue_free()
	
	
	# old arena is now gone
	
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
		#add_child(current_player)
		position_player_at_spawn()
		# idk create the starting state of the player
		
		
		
		# play the correct music
		var music_path = ""
		var playback_pos = 0.0 # this is just to skip silence at the start of some tracks
		# last level track
		print(GameData.next_arena)
		print(GameData.ARENA_ORDER.size())
		if GameData.next_arena >= GameData.ARENA_ORDER.size() - 1:
			music_path = AudioData.MUSIC_PATHS.get(AudioData.MusicKeys.LastLevel)
			AudioData.last_track = AudioData.MusicKeys.LastLevel
			playback_pos = 3.0
		# play music depending on if pings are allowed
		else:
			if GameData.allow_ping:
				music_path = AudioData.MUSIC_PATHS.get(AudioData.MusicKeys.LevelAllowPing)
				AudioData.last_track = AudioData.MusicKeys.LevelAllowPing
			else:
				music_path = AudioData.MUSIC_PATHS.get(AudioData.MusicKeys.LevelNoPing)
				AudioData.last_track = AudioData.MusicKeys.LevelNoPing
				playback_pos = 5.0
		music_player.stream = load(music_path)
		music_player.volume_db = AudioData.db_level
		
		var play_pos = playback_pos if AudioData.last_playback_position == 0.0 else AudioData.last_playback_position
		music_player.play(play_pos)
		
		print(GameData.last_arena)
		print(GameData.next_arena)
		if GameData.last_arena != GameData.next_arena:
			sfx_player.stream = load(AudioData.SFX_PATHS.get(AudioData.SFXKeys.ArenaLoad))
			sfx_player.volume_db = AudioData.db_level
			sfx_player.play(0.0)


func position_player_at_spawn():
	if current_arena != null:
		# get the spawn position
		var spawn_pos = current_arena.player_spawn_point_global_coords()
		current_player.global_position = spawn_pos

func show_victory_screen():
	get_player_ref()
	current_player.disable_movement()
	current_player.victory_screen.show_stats(current_player.clock.get_seconds(), current_player.body.get_pings_used_in_level(), current_arena.time_brackets, current_arena.ping_brackets)
	print("you won")

func end_run():
	get_player_ref()
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


