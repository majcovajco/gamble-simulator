extends CanvasLayer

@onready var game_manager = %GameManager
@onready var money_label = $Money_Label
@onready var bet_label = $AutomatUI/monitor_png/casino_background/bet_label
@onready var day = $day
@onready var fade_b = $Fade_black
@onready var power_outage_overlay = $PowerOutageOverlay
@onready var monitor = $AutomatUI
@onready var casino_hra = $AutomatUI/monitor_png/casino_background
@onready var shop_background = $AutomatUI/monitor_png/shop_background
@onready var shop_btn = $AutomatUI/monitor_png/shop_btn
@onready var casino_btn = $AutomatUI/monitor_png/casino_btn
@onready var power_off_screen = $AutomatUI/monitor_png/power_off_screen
@onready var job_select_picture = $job_select_picture

const EVENING_DIM_ALPHA = 0.12
const NO_POWER_DIM_ALPHA = 0.72

var last_money = 0
var in_animation = false

func _ready():
	money_label.text = str(Global.money)
	bet_label.text = str(monitor.win_multiplayer)
	day.text = "Day: " + str(Global.day)
	job_select_picture.visible = false
	update_power_state()
	print(monitor.spin())
	
func fade():

	in_animation = true

	var tween = create_tween()
	tween.tween_property(fade_b, "modulate:a", 1.0, 1.0)
	tween.tween_interval(0.1)
	tween.tween_property(fade_b, "modulate:a", 0.0, 1.0)

	await tween.finished

	in_animation = false

func flash(color: Color):
	money_label.modulate = color

	var tween = create_tween()
	tween.tween_property(money_label, "modulate", Color.WHITE, 0.3)
	
func update_bet():
	var current_bet = monitor.win_multiplayer
	bet_label.text = str(current_bet)

func update_money():
	var current_money = snapped(Global.money, 0.01)
	money_label.text = str(current_money)

	if current_money > last_money:
		flash(Color.GREEN)

	elif current_money < last_money:
		flash(Color.RED)

	last_money = current_money
	
func update_day():
	day.text = "Day: " + str(Global.day)
	
var monitor_open = false

func update_power_state() -> void:
	var has_power = Global.has_electricity
	var dim_alpha = 0.0
	if not has_power:
		dim_alpha = NO_POWER_DIM_ALPHA
	elif Global.is_evening:
		dim_alpha = EVENING_DIM_ALPHA

	power_outage_overlay.visible = dim_alpha > 0.0
	power_outage_overlay.color = Color(0, 0, 0, dim_alpha)
	shop_btn.visible = has_power
	casino_btn.visible = has_power

	if has_power:
		power_off_screen.visible = false
		return

	casino_hra.visible = false
	shop_background.visible = false
	power_off_screen.visible = monitor_open

func open_monitor():
	monitor_open = !monitor_open
	monitor.visible = monitor_open
	if monitor_open:
		if Global.has_electricity:
			power_off_screen.visible = false
		else:
			casino_hra.visible = false
			shop_background.visible = false
			power_off_screen.visible = true
	else:
		power_off_screen.visible = false

func close_monitor():
	monitor_open = false
	monitor.visible = false
	power_off_screen.visible = false
	casino_hra.visible = false
	shop_background.visible = false

func open_job_menu():
	job_select_picture.visible = true

func close_job_menu():
	job_select_picture.visible = false

func toggle_job_menu():
	job_select_picture.visible = !job_select_picture.visible

func start_grass_cutter():
		if Global.worked_today == false:
			#zapne scénu
			Global.is_evening = true
			get_tree().change_scene_to_file("res://scenes/grass_cutter.tscn")
		else:
			print("Už si dnes pracoval! Choď spať.")
		Global.worked_today == true

func start_pizza_maker():
	if Global.worked_today == false:
		Global.is_evening = true
		get_tree().change_scene_to_file("res://scenes/pizza_maker.tscn")
	else:
			print("Už si dnes pracoval! Choď spať.")
	Global.worked_today == true
		
func start_restaurant_game():
	if Global.worked_today == false:
		Global.is_evening = true
		get_tree().change_scene_to_file("res://scenes/server_game.tscn")
	else:
			print("Už si dnes pracoval! Choď spať.")
	Global.worked_today == true
	

func _on_shop_btn_pressed() -> void:
	if not Global.has_electricity:
		return
	print("shop stlačený")
	shop_background.visible = true

func _on_casino_btn_pressed() -> void:
	if not Global.has_electricity:
		return
	print("casino stlačené")
	casino_hra.visible = true
	
func _input(event):
	if event.is_action_pressed("restart") and game_manager.death_flag == true:
		get_tree().reload_current_scene()
