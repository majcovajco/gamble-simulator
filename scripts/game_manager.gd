extends Node

@onready var player = get_node("/root/Game/player")
@onready var UI = %UI
@onready var death_screen = %UI/Death_screen
@onready var shop_logic = $"../UI/AutomatUI/monitor_png/shop_background/scrollbar_shop"
var hungry = false
var death_flag = false

func death():
	death_screen.visible = true
	player.set_physics_process(false)
	death_flag = true
	
func work():
	if Global.worked_today == false:
		Global.worked_today = true
		Global.money += 500
		UI.update_money()

func choose_event (dict):
	var keys = dict.keys()
	var chosen_event = keys.pick_random()
	print("Chosen event: " + chosen_event)
	var multipliers = dict[chosen_event]["modifiers"]
	
	for item_name in Global.items.keys():
		var base = Global.items[item_name]["base_price"]
		var mult = 1.0 # Predvolený násobiteľ x1 (normálna cena)
		
		# Ak event ovplyvňuje tento konkrétny item, zmeníme násobiteľ
		if multipliers.has(item_name):
			mult = multipliers[item_name]
			
		# Uložíme novú cenu do slovníka
		Global.items[item_name]["current_price"] = int(base * mult)
		

func sleep():
	Global.worked_today = false
	Global.day += 1
	Global.hunger -= 1
	UI.update_day()
	choose_event(Global.events)
	shop_logic.update_market_prices()
	shop_logic.update_market_tooltips()
	if Global.hunger < 0:
		death()

func eat():
	if Global.hunger < 3:
		Global.hunger += 1
	elif Global.hunger >= 3:
		player.apply_speed_boost(250, -300, 20.0)
	Global.money -= 20
	UI.update_money()
	print(Global.hunger)

func _on_money_label_ready() -> void:
	pass # Replace with function body.
