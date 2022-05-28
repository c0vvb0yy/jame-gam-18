extends Control

onready var time_label = $VBoxContainer/TimeLabel
onready var eyes_label = $VBoxContainer/EyesLabel
onready var next_time_label = $VBoxContainer/NextRankTimeLabel
onready var next_eyes_label = $VBoxContainer/NextRankEyesLabel
onready var money_label = $VBoxContainer/MoneyLabel

var num_to_rank = {-1:"D", 3:"S", 2:"A", 1:"B", 0:"C"}
#var rank_to_num = {"S":0, "A":1, "B":2, "C":3}

var time_rank = -1
var ping_rank = -1
var money_sum = 0

func _ready():
	next_eyes_label.visible = false
	next_time_label.visible = false
	time_label.text = ""
	eyes_label.text = ""
	money_label.text = ""

func show_stats(time_taken, pings_used, time_arr, ping_arr) -> void:
	time_label.text = evaluate_time(time_taken, time_arr)
	eyes_label.text = evaluate_pings(pings_used, ping_arr)
	evaluate_money()
	money_label.text = str("Got ", money_sum, "G")
	pass


func evaluate_time(time_taken, time_arr) -> String:
	time_taken = stepify(time_taken, 0.01) #rounding to counter-equal display
	var numerical_rank = -1 #-1 == D rank
	for i in time_arr.size(): #go through array to see in which bracket we fall (if any)
		if time_taken <= time_arr[i]:
			#we found our rank
			numerical_rank = i
	#construct next_rank_string
	if numerical_rank < 3 :
		var next_rank = numerical_rank+1
		var next_rank_string = str("Need ", time_arr[next_rank], " for ", num_to_rank[next_rank], "  rank")
		next_time_label.visible = true
		next_time_label.text = next_rank_string
	time_rank = numerical_rank
	var time_string = str("Took ", time_taken, "s - ", num_to_rank[numerical_rank], " rank!")
	return time_string

func evaluate_pings(pings_used, ping_arr) -> String :
	if(ping_arr[ping_arr.size()-1] == 0):
		#then S rank is zero and player-inactivity should not be praised 
		ping_rank = -1
		return ""
	var numerical_rank = -1
	for i in ping_arr.size():
		if pings_used <= ping_arr[i]:
			numerical_rank = i
	#construct next rank string
	if numerical_rank < 3:
		var next_rank = numerical_rank+1
		var next_rank_string = str("Need ", ping_arr[next_rank], " for ", num_to_rank[next_rank], " rank")
	ping_rank = numerical_rank
	var ping_string = str("Used ", pings_used, " - ", num_to_rank[numerical_rank], " rank!")
	return ping_string

func evaluate_money():
	var time_mult = time_rank + 2
	var ping_mult = ping_rank + 2
	money_sum = time_mult * ping_mult
	