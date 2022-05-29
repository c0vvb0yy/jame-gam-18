extends Node

# array of file paths to the arenas, in order
const ARENA_ORDER = [
	"res://src/level/arenas/arena0.tscn", # 0
	"res://src/level/arenas/arena1.tscn", # 1
	"res://src/level/arenas/arena2.tscn", # 2
	"res://src/level/arenas/arena2-1.tscn", # 3
	"res://src/level/arenas/arena3.tscn", # 4
	"res://src/level/arenas/arena3-0-1.tscn", # 5
	"res://src/level/arenas/arena3-1.tscn", # 6
	"res://src/level/arenas/arena4.tscn", # 7
	"res://src/level/arenas/arena4-1.tscn", # 8
	"res://src/level/arenas/arena4-2.tscn", # 9
	"res://src/level/arenas/arena4-3.tscn", # 10
	"res://src/level/arenas/arena5.tscn", # 11
	"res://src/level/arenas/arena5-1.tscn", # 12
	"res://src/level/arenas/arena5-2.tscn", # 13
	"res://src/level/arenas/arena5-3.tscn", # 14
	"res://src/level/arenas/arena6.tscn", # 15
	"res://src/level/arenas/arena9.tscn", # 16
	"res://src/level/arenas/arena7-1.tscn", # 17
	"res://src/level/arenas/arena-7-1-1.tscn", # 18
	"res://src/level/arenas/arena8.tscn", # 19
	"res://src/level/arenas/arena8-1.tscn", # 20
	"res://src/level/arenas/arena8-2.tscn", # 21
	"res://src/level/arenas/arena7.tscn" # 22
]

# var used in the main menu button selection to tell the arena controller which arena to load first / next
var last_arena = -1
var next_arena = 0

var allow_grappling_hook = true
var allow_ping = true
