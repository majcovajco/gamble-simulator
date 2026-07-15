extends Node

@onready var player = get_node("/root/Game/player")
@onready var UI = get_node("/root/Game/UI")
@onready var death_screen = get_node("/root/Game/UI/Death_screen")
@onready var shop_logic = get_node("/root/Game/UI/AutomatUI/monitor_png/shop_background/scrollbar_shop")
@onready var day_end_panel = get_node("/root/Game/UI/day_end_panel")

var hungry = false
var death_flag = false
var finish_sleep_connected = false
var sleep_panel_open = false

func _ready():
	if not finish_sleep_connected:
		day_end_panel.sleep_confirmed.connect(_finish_sleep)
		finish_sleep_connected = true

func death():
	death_screen.visible = true
	player.set_physics_process(false)
	death_flag = true

func work():
	if !Global.worked_today:
		Global.worked_today = true
		Global.money += 500
		UI.update_money()

func choose_event(dict):
	var keys = dict.keys()
	var chosen_event = keys.pick_random()
	print("Chosen event: " + chosen_event)
	var multipliers = dict[chosen_event]["modifiers"]

	for item_name in Global.items.keys():
		var base = Global.items[item_name]["base_price"]
		var mult = 1.0

		if multipliers.has(item_name):
			mult = multipliers[item_name]

		Global.items[item_name]["current_price"] = int(base * mult)

func show_end_day_panel():
	day_end_panel.reset_panel()
	day_end_panel.visible = true

func hide_end_day_panel():
	sleep_panel_open = false
	day_end_panel.visible = false

# Túto funkciu naďalej volajú ostatné skripty
func sleep():
	if sleep_panel_open:
		return

	sleep_panel_open = true
	show_end_day_panel()

# Zavolá sa až po kliknutí na Pay
func _finish_sleep():
	if not sleep_panel_open:
		return

	sleep_panel_open = false
	Global.worked_today = false
	Global.is_evening = false
	Global.day += 1
	Global.hunger -= 1

	UI.update_day()
	UI.fade()

	choose_event(Global.events)
	shop_logic.update_market_prices()
	shop_logic.update_market_tooltips()
	UI.update_power_state()

	if Global.hunger < 0:
		death()

func eat():
	if not Global.has_electricity:
		print("Bez elektriny sa z chladnicky neda jest.")
		return

	if Global.hunger < 3:
		Global.hunger += 1
	else:
		player.apply_speed_boost(250, -300, 20.0)

	Global.money -= 20
	UI.update_money()

	print(Global.hunger)

func _on_money_label_ready() -> void:
	pass
