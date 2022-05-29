extends HBoxContainer

var upgrade = 0
var price = 0

signal update_money_label

onready var button = $TextureButton
onready var label_name = $VBoxContainer/LabelName
onready var label_desc = $VBoxContainer/LabelDesc
onready var audio_player = $AudioStreamPlayer

func set_upgrade(value: int):
	upgrade = value
	
	button.texture_normal = load(UpgradeData.BUTTON_NORMAL_TEX.get(upgrade))
	button.texture_hover = load(UpgradeData.BUTTON_HOVER_TEX.get(upgrade))
	
	label_name.text = UpgradeData.UPGRADE_NAMES.get(upgrade)
	label_desc.text = UpgradeData.UPGRADE_DESCRIPTIONS.get(upgrade)
	
	
	
	# owned
	var is_owned = UpgradeData.upgrade_got_data.get(upgrade)
	if is_owned:
		label_name.text += " (owned)"
	else:
		price = UpgradeData.UPGRADE_PRICES.get(upgrade)
		label_desc.text += str("\ncost: ", price, " G")
	
	
func buy_upgrade():
	var enough_money = PlayerData.player_money >= price
	if enough_money:
		UpgradeData.upgrade_got_data[upgrade] = true
		UpgradeData.save_upgrade_data()
		set_upgrade(upgrade) # call this to update the visuals
		PlayerData.player_money -= price
		
		# tell the main menu controller to update the money label
		var controllers = get_tree().get_nodes_in_group("MainMenuController")
		if controllers.size() > 0:
			var controller = controllers[0]
			connect("update_money_label", controller, "update_money_label")
			emit_signal("update_money_label")
			disconnect("update_money_label", controller, "update_money_label")
		

func _on_TextureButton_button_up() -> void:
	var is_owned = UpgradeData.upgrade_got_data.get(upgrade)
	#print(is_owned)
	if !is_owned: 
		buy_upgrade()


func _on_TextureButton_button_down() -> void:
	AudioData.play_button_click(audio_player)


func _on_ShopItem_mouse_entered() -> void:
	AudioData.play_button_hover(audio_player)
