extends Node

@onready var pizza_name_label = $"../HUD/Top_bar/Pizza_type"
@onready var confirm_popup = $"../HUD/confirm_popup"
@onready var cursor = $"../cursor_sprite2D"
@onready var pizza_base = $"../pizza_base"
@onready var sauce_drop_area = $"../SauceDropArea"
@onready var pizza_timer = $"../Pizza_timer"
@onready var score_label = $"../HUD/Top_bar/ScoreLabel"
@onready var time_countdown_bar = $"../HUD/Time_countdown"
@onready var end_panel = $"../HUD/end_panel"
@onready var end_money_label = $"../HUD/end_panel/End_money_label"
@onready var end_msg = $"../HUD/end_panel/msg_end"

const CURSOR_HOTSPOT_OFFSET = Vector2(10, 20)
const INITIAL_TIMER_TIME = 10.0
const TIMER_DECREASE_PER_SERVE = 1.5
const MIN_TIMER_TIME = 2.0
const BAD_SERVE_PENALTY = -20
const TRASH_PENALTY = -10
const FEEDBACK_FLASH_TIME = 0.18

const LADLE = preload("res://assets/ladle_sauce.png")
const CHEESE_CURSOR = preload("res://assets/cheese_pile.png")
const BASIL_CURSOR = preload("res://assets/basil.png")
const SALAMI_CURSOR = preload("res://assets/salami.png")
const MUSHROOM_CURSOR = preload("res://assets/mushroom.png")
const PIZZA_BASE = preload("res://assets/pizza_base.png")
const SAUCE_BASE = preload("res://assets/base_sauced.png")
const CHEESE_BASE = preload("res://assets/base_cheesed.png")
const BASIL_BASE = preload("res://assets/base_basil.png")
const SALAMI_PIZZA = preload("res://assets/salami_pizza.png")
const MUSHROOM_PIZZA = preload("res://assets/mushroom_pizza.png")


var recipes = [
	{ "name": "Margarita", "ingredients": ["sauce", "cheese", "basil"] },
	{ "name": "Salami", "ingredients": ["sauce", "cheese", "basil", "salami"] },
	{ "name": "Mushroom", "ingredients": ["sauce", "cheese", "basil", "mushroom"] }
]

var score = 0
var difficulty_multiplier = 1.0
var current_timer_time = INITIAL_TIMER_TIME

var current_order = {}
var current_pizza_ingredients = []
var feedback_overlay: CanvasLayer
var feedback_rect: ColorRect
var dragging_sauce = false
var sauce_applied = false
var dragging_cheese = false
var cheese_applied = false
var dragging_basil = false
var basil_applied = false
var dragging_salami = false
var salami_applied = false
var dragging_mushroom = false
var mushroom_applied = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	cursor.visible = false
	cursor.texture = LADLE
	cursor.centered = true
	
	randomize()
	pizza_timer.wait_time = INITIAL_TIMER_TIME
	pizza_timer.timeout.connect(_on_pizza_timer_timeout)
	if has_node("../HUD/end_panel/OK_Button"):
		$"../HUD/end_panel/OK_Button".pressed.connect(_on_end_ok_pressed)
	_create_feedback_overlay()
	generate_order()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if dragging_sauce or dragging_cheese or dragging_basil or dragging_salami or dragging_mushroom:
		cursor.global_position = get_viewport().get_mouse_position() + CURSOR_HOTSPOT_OFFSET
	_update_timer_bar()

func _create_feedback_overlay() -> void:
	feedback_overlay = CanvasLayer.new()
	feedback_overlay.layer = 100
	feedback_overlay.name = "PizzaFeedbackOverlay"
	add_child(feedback_overlay)
	
	feedback_rect = ColorRect.new()
	feedback_rect.name = "FeedbackRect"
	feedback_rect.color = Color(1, 1, 1, 0)
	feedback_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	feedback_rect.set_anchors_preset(Control.PRESET_FULL_RECT)
	feedback_overlay.add_child(feedback_rect)

func _flash_feedback(color: Color) -> void:
	if not feedback_rect:
		return
	
	feedback_rect.color = color
	feedback_rect.modulate = Color(1, 1, 1, 0.35)
	var tween = create_tween()
	tween.tween_property(feedback_rect, "modulate", Color(1, 1, 1, 0.0), FEEDBACK_FLASH_TIME)

func _start_order_timer() -> void:
	pizza_timer.stop()
	pizza_timer.wait_time = max(MIN_TIMER_TIME, current_timer_time)
	pizza_timer.start()
	_update_timer_bar()

func _update_timer_bar() -> void:
	if not time_countdown_bar:
		return
	
	time_countdown_bar.max_value = max(0.01, pizza_timer.wait_time)
	time_countdown_bar.value = max(0.0, pizza_timer.time_left)
	
	if pizza_timer.time_left <= pizza_timer.wait_time * 0.25:
		time_countdown_bar.modulate = Color(1.0, 0.25, 0.25)
	else:
		time_countdown_bar.modulate = Color(1.0, 1.0, 1.0)
	
func generate_order():
	# `recipes` je pole, takže si vyberieme náhodný prvok priamo z poľa
	var chosen_recipe = recipes[randi() % recipes.size()]
	
	current_order = chosen_recipe
	current_pizza_ingredients = []
	sauce_applied = false
	cheese_applied = false
	cheese_applied = false
	basil_applied = false
	salami_applied = false
	mushroom_applied = false
	pizza_base.texture = PIZZA_BASE
	
	# Nastavíme label na názov vybranej pizze
	if pizza_name_label:
		pizza_name_label.text = chosen_recipe["name"]
	
	_start_order_timer()

func _on_back_button_pressed() -> void:
	confirm_popup.show()
	print("Späť do hlavného menu")
	pizza_timer.paused = true

func _on_thrash_button_pressed() -> void:
	print("Pizza vyhodená do koša!")
	current_pizza_ingredients.clear()
	sauce_applied = false
	cheese_applied = false
	basil_applied = false
	salami_applied = false
	mushroom_applied = false
	pizza_base.texture = PIZZA_BASE
	score += TRASH_PENALTY
	score_label.text = "Score: " + str(score)
	_flash_feedback(Color(1.0, 0.2, 0.2))

func _on_confirm_yes_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/game.tscn")

func _on_end_ok_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/game.tscn")

func _on_confirm_no_pressed() -> void:
	confirm_popup.hide()
	pizza_timer.paused = false
	pizza_timer.start()
	_update_timer_bar()

var pizza_bad = false
func _on_bake_button_pressed() -> void:
	pizza_bad = false
	print("Pizza sa podáva!")
	print("Čakáme: ", current_order["ingredients"])
	print("Máme naklikané: ", current_pizza_ingredients)
	
	#kontrola správnosti pizze
	if current_order["ingredients"].size() != current_pizza_ingredients.size():
		pizza_bad = true
	
	for i in range (current_pizza_ingredients.size()):
		if current_order["ingredients"][i] == current_pizza_ingredients[i]:
			print("ok")
		else:
			print("zlá pizza")
			pizza_bad = true
			break
	
	if not pizza_bad:
		#započítame skóre
		score += max(1, 100 + int(difficulty_multiplier * pizza_timer.time_left))
		score_label.text = "Score: " + str(score)
		current_timer_time = max(MIN_TIMER_TIME, current_timer_time - TIMER_DECREASE_PER_SERVE)
		_flash_feedback(Color(0.2, 1.0, 0.2))
	else:
		score += BAD_SERVE_PENALTY
		score_label.text = "Score: " + str(score)
		_flash_feedback(Color(1.0, 0.2, 0.2))
	
	difficulty_multiplier += 0.05
	#nová order iba ak máme správnu pizzu
	if not pizza_bad:
		generate_order()

func _on_pizza_timer_timeout() -> void:
	print("Čas vypršal, končí sa minihra")
	end_game()

func end_game() -> void:
	pizza_timer.stop()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	end_panel.show()
	end_money_label.text = "Earned: " + str(score) + "$"
	end_msg.text = "Time is up!"
	
func _on_ingredient_sauce_button_down() -> void:
	dragging_sauce = true
	cursor.texture = LADLE
	cursor.visible = true
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _on_ingredient_sauce_button_up() -> void:
	if not dragging_sauce:
		return
	
	dragging_sauce = false
	cursor.visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	if sauce_drop_area.get_global_rect().has_point(get_viewport().get_mouse_position()):
		print("Omáčka dopadla na pizzu")
		if not sauce_applied:
			current_pizza_ingredients.append("sauce")
			sauce_applied = true
			pizza_base.texture = SAUCE_BASE
		else:
			print("Omáčka už je aplikovaná")
	else:
		print("Omáčka minula pizzu")

func _on_ingredient_cheese_button_down() -> void:
	dragging_cheese = true
	cursor.visible = true
	cursor.texture = CHEESE_CURSOR
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _on_ingredient_cheese_button_up() -> void:
	if not dragging_cheese:
		return
	
	dragging_cheese = false
	cursor.visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	if sauce_drop_area.get_global_rect().has_point(get_viewport().get_mouse_position()):
		print("Syr dopadol na pizzu")
		if not cheese_applied and sauce_applied:
			current_pizza_ingredients.append("cheese")
			cheese_applied = true
			pizza_base.texture = CHEESE_BASE
	else:
		print("Syr minul pizzu")

func _on_ingredient_basil_button_down() -> void:
	dragging_basil = true
	cursor.visible = true
	cursor.texture = BASIL_CURSOR
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _on_ingredient_basil_button_up() -> void:
	if not dragging_basil:
		return
	
	dragging_basil = false
	cursor.visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	if sauce_drop_area.get_global_rect().has_point(get_viewport().get_mouse_position()):
		print("Basil dopadol na pizzu")
		if not basil_applied and sauce_applied and cheese_applied:
			current_pizza_ingredients.append("basil")
			basil_applied = true
			pizza_base.texture = BASIL_BASE
		else:
			print("Basil už je aplikovaný")
	else:
		print("Basil minul pizzu")
		
func _on_ingredient_mushroom_button_down() -> void:
	dragging_mushroom = true
	cursor.visible = true
	cursor.texture = MUSHROOM_CURSOR
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _on_ingredient_mushroom_button_up() -> void:
	if not dragging_mushroom:
		return
	
	dragging_mushroom = false
	cursor.visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	if sauce_drop_area.get_global_rect().has_point(get_viewport().get_mouse_position()):
		print("Basil dopadol na pizzu")
		if not mushroom_applied and (pizza_base.texture != SALAMI_PIZZA) and basil_applied and sauce_applied and cheese_applied:
			current_pizza_ingredients.append("mushroom")
			mushroom_applied = true
			pizza_base.texture = MUSHROOM_PIZZA
		else:
			print("Basil už je aplikovaný")
	else:
		print("Basil minul pizzu")

func _on_ingredient_salami_button_down() -> void:
	dragging_salami = true
	cursor.visible = true
	cursor.texture = SALAMI_CURSOR
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	
func _on_ingredient_salami_button_up() -> void:
	if not dragging_salami:
		return
	
	dragging_salami = false
	cursor.visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	if sauce_drop_area.get_global_rect().has_point(get_viewport().get_mouse_position()):
		print("Basil dopadol na pizzu")
		if not salami_applied and (pizza_base.texture != MUSHROOM_PIZZA) and basil_applied and sauce_applied and cheese_applied:
			current_pizza_ingredients.append("salami")
			salami_applied = true
			pizza_base.texture = SALAMI_PIZZA
		else:
			print("Basil už je aplikovaný")
	else:
		print("Basil minul pizzu")
