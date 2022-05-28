extends Node

# array of file paths to the arenas, in order
const ARENA_ORDER = [
#	"res://src/level/arenas/arena0.tscn", # 0
	"res://src/level/arenas/arena1.tscn", # 1
#	"res://src/level/arenas/arena2.tscn", # 2
#	"res://src/level/arenas/arena2-1.tscn", # 3
	"res://src/level/arenas/arena3.tscn", # 4
#	"res://src/level/arenas/arena3-0-1.tscn", # 5
#	"res://src/level/arenas/arena3-1.tscn", # 6
#	"res://src/level/arenas/arena4.tscn", # 7
#	"res://src/level/arenas/arena4-1.tscn", # 8
	"res://src/level/arenas/arena4-2.tscn" # 9
]

# var used in the main menu button selection to tell the arena controller which arena to load first / next
var last_arena = -1
var next_arena = 0

var allow_grappling_hook = true
var allow_ping = true
