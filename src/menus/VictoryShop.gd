extends Control

onready var money_label = $HBoxContainer/Label

onready var background = $BG

var shop_item = preload("res://src/menus/ShopItem.tscn")


func _ready() -> void:
	visible = false
	create_shop_items()

func create_shop_items():
	for c in get_children():
		if c is HBoxContainer && !c.is_in_group("Protected"):
			c.queue_free()
	
	for i in range(4):
		var item = shop_item.instance()
		add_child(item)
		item.set_upgrade(i)
	
	# shop label
	money_label.text = str(PlayerData.player_money, "  G")

func update_money_label():
	money_label.text = str(PlayerData.player_money, " G")
	UpgradeData.save_upgrade_data()


func _on_BackButton_button_up() -> void:
	visible = false


func _on_VictoryShop_visibility_changed() -> void:
	background.visible = visible
	var goals = get_tree().get_nodes_in_group("PlayerGoal")
	if goals.size() > 0:
		var goal = goals[0]
		goal.visible = !visible
