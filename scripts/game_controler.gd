extends Node

const CUSTOMER = preload("res://scenes/customer.tscn")
const MEAL = preload("res://scenes/meal.tscn")
const PLAYER = preload("res://scenes/server_player.tscn")

var score = 0
var difficulty_multiplier = 1.0
var lives = 3
var spawn_timer: Timer
var meal_options = ["burger", "salad", "pizza"]
var game_over = false

@onready var spawn_points = $"../customer_points"
@onready var meal_points = $"../meal_points"
@onready var confirm_popup = $"../HUD/confirmPanel"
@onready var hud_score = $"../HUD/TopBar/Score"
@onready var hud_lives = $"../HUD/TopBar/Lives"

var occupied_points: Array = []
var active_customers: Array = []
var active_meals: Array = []

func _ready() -> void:
	if Global.worked_today:
		print("[game_controler] work already done today")
		get_tree().change_scene_to_file("res://scenes/game.tscn")
		return
	Global.worked_today = true
	spawn_timer = Timer.new()
	spawn_timer.wait_time = 3.2
	spawn_timer.autostart = true
	spawn_timer.timeout.connect(_spawn_customer)
	add_child(spawn_timer)

	var player: Node = get_tree().current_scene.find_child("server_player", false, false)
	if player == null:
		player = PLAYER.instantiate()
		player.name = "server_player_runtime"
		get_tree().current_scene.add_child(player)
		print("[game_controler] spawned player -> parent:", player.get_parent(), "global_pos:", player.global_position)
	else:
		print("[game_controler] reused existing player ->", player.name)

	player.global_position = Vector2(700, 480)
	if player is Node2D:
		player.z_index = 100
	if player.has_node("AnimatedSprite"):
		var spr = player.get_node("AnimatedSprite")
		spr.visible = true
		spr.modulate = Color(1,1,1,1)
		spr.z_index = 200
	else:
		print("[game_controler] WARNING: player has no AnimatedSprite node")

	var vp = get_viewport().get_visible_rect()
	print("[game_controler] viewport rect:", vp)
	print("[game_controler] current_scene children:")
	for c in get_tree().current_scene.get_children():
		print(" -", c.name, "(", c, ")")
	player.owner = get_tree().current_scene

	update_hud()

func _process(_delta: float) -> void:
	pass

func _spawn_customer() -> void:
	if game_over:
		return
	var all_points = spawn_points.get_children()
	var free_points = all_points.filter(func(p): return not occupied_points.has(p))
	if free_points.is_empty():
		return

	free_points.shuffle()
	var chosen = free_points[0]
	occupied_points.append(chosen)

	var customer = CUSTOMER.instantiate()
	customer.position = chosen.position
	customer.spawn_point = chosen
	customer.connect("order_chosen", _on_customer_order_chosen)
	customer.connect("customer_served", _on_customer_served)
	customer.connect("customer_left", _on_customer_left)
	get_tree().current_scene.add_child(customer)
	active_customers.append(customer)

	spawn_timer.wait_time = max(0.9, 2.4 - (difficulty_multiplier * 0.15))

func _on_customer_order_chosen(meal_name: String, customer: Node) -> void:
	var free_meal_points = meal_points.get_children().filter(func(p): return not active_meals.has(p))
	if free_meal_points.is_empty():
		return

	free_meal_points.shuffle()
	var chosen_point = free_meal_points[0]
	active_meals.append(chosen_point)

	var meal = MEAL.instantiate()
	meal.position = chosen_point.position
	meal.meal_name = meal_name
	meal.spawn_point = chosen_point
	meal.connect("meal_collected", _on_meal_collected)
	get_tree().current_scene.add_child(meal)

func _on_meal_collected(spawn_point: Node) -> void:
	active_meals.erase(spawn_point)

func _on_customer_served(customer: Node) -> void:
	score += 30 + (10 * difficulty_multiplier)
	difficulty_multiplier += 0.08
	active_customers.erase(customer)
	update_hud()

func _on_customer_left(customer: Node, was_served: bool) -> void:
	if customer.spawn_point != null:
		occupied_points.erase(customer.spawn_point)
	active_customers.erase(customer)
	if not was_served:
		lives -= 1
		update_hud()
		if lives <= 0:
			_trigger_game_over()

func _trigger_game_over() -> void:
	if game_over:
		return
	game_over = true
	if spawn_timer != null:
		spawn_timer.stop()
	Global.money += score
	var end_panel = get_tree().current_scene.get_node("HUD/EndPanel")
	if end_panel != null:
		end_panel.visible = true
		var title = end_panel.get_node_or_null("EndLabel")
		var money_label = end_panel.get_node_or_null("EndMoneyLabel")
		if title != null and title is Label:
			title.text = "Shift Finished"
		if money_label != null and money_label is Label:
			money_label.text = "Money earned: $" + str(score)
	else:
		print("[game_controler] WARNING: HUD/EndPanel not found")

func update_hud() -> void:
	hud_score.text = "Score: " + str(score)
	hud_lives.text = "Lives: " + str(lives)

func _on_back_button_pressed() -> void:
	confirm_popup.show()

func _on_yes_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/game.tscn")

func _on_no_button_pressed() -> void:
	confirm_popup.hide()

func _on_ok_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/game.tscn")
