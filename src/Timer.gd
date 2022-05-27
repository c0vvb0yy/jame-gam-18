extends Node


onready var label = $Label

var elapsed_time = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	elapsed_time += delta
	
	label.text = format_time()

func format_time() -> String:
	var minutes = elapsed_time / 60
	var seconds = fmod(elapsed_time, 60)
	var milliseconds = fmod(elapsed_time, 1) * 100
	
	var time_string := "%02d:%02d:%02d" % [minutes, seconds, milliseconds]
	
	return time_string
