extends Node2D


onready var tween = $Tween
onready var blades_front = $BladesFront
onready var collider_front = $BladesBack/DeathZone
onready var blades_back = $BladesBack
onready var collider_back = $BladesBack/DeathZone
onready var blades_top = $BladesTop
onready var collider_top = $BladesTop/DeathZone


# tilemaps
onready var front_tr = $BladesFront/TileMapDeath
onready var front_hl = $BladesFront/TileMapDeathHL
onready var back_tr = $BladesBack/TileMapDeath
onready var back_hl = $BladesBack/TileMapDeathHL
onready var top_tr = $BladesTop/TileMapDeath
onready var top_hl = $BladesTop/TileMapDeathHL

onready var body_tr = $TileMap
onready var body_hl = $TileMapHL

export var counter_clockwise = false

export var front_blades = true
export var back_blades = true
export var top_blades = true

export var highlight_blades = false
export var highlight_body = true

func _ready() -> void:
	rotate_windmill()
	if counter_clockwise:
		scale.y = -1
	

	blades_front.visible = front_blades
	collider_front.monitoring = front_blades
	blades_back.visible = back_blades
	collider_back.monitoring = back_blades
	blades_top.visible = top_blades
	collider_top.monitoring = top_blades
	
	
	front_tr.visible = !highlight_blades
	front_hl.visible = highlight_blades
	back_tr.visible = !highlight_blades
	back_hl.visible = highlight_blades
	top_tr.visible = !highlight_blades
	top_hl.visible = highlight_blades
	
	body_tr.visible =  !highlight_body
	body_hl.visible =  highlight_body
	


func rotate_windmill():
	var target_rot = -360 if counter_clockwise else 360
	tween.interpolate_property(self, "rotation_degrees", 0, target_rot, 10.0)
	tween.start()

func _on_Tween_tween_all_completed() -> void:
	rotate_windmill()
