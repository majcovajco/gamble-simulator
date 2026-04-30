extends CanvasLayer

@onready var game_manager = %GameManager
@onready var money_label = $Money_Label
@onready var bet_label = $AutomatUI/monitor_png/casino_background/bet_label
@onready var day = $day
@onready var fade_b = $Fade_black
@onready var monitor = $AutomatUI
@onready var casino_hra = $AutomatUI/monitor_png/casino_background
@onready var shop_background = $AutomatUI/monitor_png/shop_background

var last_money = 0
var in_animation = false

func _ready():
	money_label.text = str(game_manager.money)
	bet_label.text = str(monitor.win_multiplayer)
	day.text = "Day: " + str(game_manager.day)
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
	var current_money = snapped(game_manager.money, 0.01)
	money_label.text = str(current_money)

	if current_money > last_money:
		flash(Color.GREEN)

	elif current_money < last_money:
		flash(Color.RED)

	last_money = current_money
	
func update_day():
	day.text = "Day: " + str(game_manager.day)
	
var monitor_open = false

func open_monitor():
	monitor_open = !monitor_open
	monitor.visible = monitor_open


func _on_shop_btn_pressed() -> void:
	print("shop stlačený")
	shop_background.visible = true

func _on_casino_btn_pressed() -> void:
	print("casino stlačené")
	casino_hra.visible = true
	
func _input(event):
	if event.is_action_pressed("restart") and game_manager.death_flag == true:
		get_tree().reload_current_scene()
