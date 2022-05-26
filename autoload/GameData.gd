extends Node

# array of file paths to the arenas, in order
const ARENA_ORDER = [
	"res://src/level/arenas/arena0.tscn",
	"res://src/level/arenas/arena1.tscn",
	"res://src/level/arenas/arena2.tscn",
	"res://src/level/arenas/arena2-1.tscn"
]

var next_arena = 3 # var used in the main menu button selection to tell the arena controller which arena to load first


var allow_grappling_hook = true
var allow_ping = true
