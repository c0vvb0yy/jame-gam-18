
extends Node


var save_path = "user://skully.json"



enum Upgrades {
	ThirdEye,
	HardGrapple,
	ThirdJump,
	PingRange
}


var upgrade_got_data = {
	Upgrades.ThirdEye : false,
	Upgrades.HardGrapple : false,
	Upgrades.ThirdJump : false,
	Upgrades.PingRange : false
}

const BUTTON_HOVER_TEX = {
	Upgrades.ThirdEye : "res://assets/ui/upgrades/upgrade_eye_hover.png",
	Upgrades.HardGrapple : "res://assets/ui/upgrades/upgrade_grapple_hover.png",
	Upgrades.ThirdJump : "res://assets/ui/upgrades/upgrade_jump_hover.png",
	Upgrades.PingRange : "res://assets/ui/upgrades/upgrade_ping_hover.png"
}
const BUTTON_NORMAL_TEX = {
	Upgrades.ThirdEye : "res://assets/ui/upgrades/upgrade_eye_normal.png",
	Upgrades.HardGrapple : "res://assets/ui/upgrades/upgrade_grapple_normal.png",
	Upgrades.ThirdJump : "res://assets/ui/upgrades/upgrade_jump_normal.png",
	Upgrades.PingRange : "res://assets/ui/upgrades/upgrade_ping_normal.png"
}

const UPGRADE_PRICES = {
	Upgrades.ThirdEye : 100,
	Upgrades.HardGrapple : 100,
	Upgrades.ThirdJump : 100,
	Upgrades.PingRange : 100
}

const UPGRADE_NAMES = {
	Upgrades.ThirdEye : "Third Eye",
	Upgrades.HardGrapple : "Eldritch Pull",
	Upgrades.ThirdJump : "Vapor Delving",
	Upgrades.PingRange : "Lustrous Cornea"
}

const UPGRADE_DESCRIPTIONS = {
	Upgrades.ThirdEye : "an extra eye per clip",
	Upgrades.HardGrapple : "the grappling hook shoots out faster and pulls you in stronger",
	Upgrades.ThirdJump : "jump thrice",
	Upgrades.PingRange : "strengthens the illumination of your eyes"
}

func has_upgrade(upgrade: int):
	return upgrade_got_data.get(upgrade)



func load_upgrade_data():
	var file = File.new()
	file.open(save_path, File.READ)
	var text = file.get_as_text()
	file.close()
	var result = parse_json(text)
	upgrade_got_data = result.get("upgrade_got_data")
	# when loading the achievement_completed_data, the keys get converted into Strings, so we need to fix that
	var actual_data = {}
	for key in upgrade_got_data:
		actual_data[int(key)] = upgrade_got_data.get(key)
	upgrade_got_data = actual_data
	
	
	PlayerData.player_money = result.get("player_money")
	
	
	
	var fuck = result.get("finished_levels")
	var actual_data_levels = []
	for entry in fuck:
		actual_data_levels.append(int(entry))
	
	PlayerData.finished_levels = actual_data_levels
	
	
	
	




func save_upgrade_data() -> void:
	var data = {}
	data["upgrade_got_data"] = upgrade_got_data
	data["player_money"] = PlayerData.player_money
	data["finished_levels"] = PlayerData.finished_levels
	print(data)
	var save_file = File.new()
	save_file.open(save_path, File.WRITE)
	save_file.store_line(to_json(data))
	save_file.close()
