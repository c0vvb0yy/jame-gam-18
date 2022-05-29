extends Node2D


onready var tween = $Tween
onready var blades_front_ref = $BladesFront
onready var death_zone_front_ref = $BladesFront/DeathZone
onready var blades_back_ref = $BladesBack
onready var death_zone_back_ref = $BladesBack/DeathZone
onready var blades_top_ref = $BladesTop
onready var death_zone_top_ref = $BladesTop/DeathZone


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

export var rotation_timer = 10.0

func _ready() -> void:
	rotate_windmill()
	if counter_clockwise:
		scale.y = -1
	
	blades_front_ref.visible = front_blades
	death_zone_front_ref.monitorable = front_blades
	death_zone_front_ref.monitoring = front_blades
	#death_zone_front_ref.set_enabled(front_blades)
	#death_zone_front_ref.set_collision_layer_bit(2, front_blades)
	#death_zone_front_ref.monitoring = front_blades
	blades_back_ref.visible = back_blades
	death_zone_back_ref.monitorable = back_blades
	death_zone_back_ref.monitoring = back_blades
	#death_zone_back_ref.set_enabled(back_blades)
	#death_zone_back_ref.set_collision_layer_bit(2, back_blades)
	#death_zone_back_ref.monitoring = back_blades
	blades_top_ref.visible = top_blades
	death_zone_top_ref.monitorable = top_blades
	death_zone_top_ref.monitoring = top_blades
	#death_zone_top_ref.set_enabled(top_blades)
	#death_zone_top_ref.set_collision_layer_bit(2, top_blades)
	#death_zone_top_ref.monitoring = top_blades
	
	
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
	tween.interpolate_property(self, "rotation_degrees", 0, target_rot, rotation_timer)
	tween.start()

func _on_Tween_tween_all_completed() -> void:
	rotate_windmill()
