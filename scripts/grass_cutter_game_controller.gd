extends Node

const GARDEN_OBJECT = preload("res://scenes/garden_object.tscn")
const SCISSORS_OPENED = preload("res://assets/scissors_opened.png")
const SCISSORS_CLOSED = preload("res://assets/scissors_closed.png")
const CURSOR_HOTSPOT_OFFSET = Vector2(10, 20)

@onready var confirm_popup = $"../HUD/ConfirmPopup"
@onready var spawn_points = $"../SpawnPoints"
@onready var spawn_layer = $"../SpawnLayer"
@onready var spawn_timer = $"../SpawnTimer"
@onready var scissors_cursor = $"../ScissorsCursor"
@onready var score_label = $"../HUD/TopBar/ScoreLabel"
@onready var lives_label = $"../HUD/TopBar/LivesLabel"
@onready var end_panel = $"../HUD/EndPanel"
@onready var end_money_label = $"../HUD/EndPanel/EndMoneyLabel"
@onready var end_msg = $"../HUD/EndPanel/msg_end"

# flag for end msg
var kytka_down = false
#-------
var score = 0
var lives = 3
var missed_weeds = 0
var difficulty_multiplier = 1.0
var occupied_points: Array = []

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	scissors_cursor.texture = SCISSORS_OPENED
	scissors_cursor.centered = true
	spawn_timer.timeout.connect(_spawn_plant)
	spawn_timer.start()

func _process(_delta: float) -> void:
	scissors_cursor.global_position = get_viewport().get_mouse_position() + CURSOR_HOTSPOT_OFFSET
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		scissors_cursor.texture = SCISSORS_CLOSED
	else:
		scissors_cursor.texture = SCISSORS_OPENED

func _spawn_plant() -> void:
	var all_points = spawn_points.get_children()
	var free_points = all_points.filter(func(p): return not occupied_points.has(p))
	if free_points.is_empty():
		return
	free_points.shuffle()
	var chosen = free_points[0]
	occupied_points.append(chosen)

	var obj = GARDEN_OBJECT.instantiate()
	obj.position = chosen.position
	obj.spawn_point = chosen
	obj.connect("plant_clicked", _on_plant_clicked)
	obj.connect("plant_despawned", _on_plant_despawned)
	
	obj.current_difficulty = difficulty_multiplier
	
	spawn_timer.wait_time = max(0.4, 1.5 / difficulty_multiplier)
	spawn_layer.add_child(obj)

	difficulty_multiplier += 0.05

func _on_plant_clicked(obj, spawn_point, plant_type) -> void:
	occupied_points.erase(spawn_point)

	match plant_type:
		"grass":
			score += int(3 * difficulty_multiplier)
		"flower":
			game_over()
		"branch":
			score += int(10 * difficulty_multiplier)
		"weed":
			var random_chance = randf()
			if random_chance < 0.33:
				kytka_down = true
				game_over()
			elif random_chance < 0.66:
				score += int(3 * difficulty_multiplier)
			else:
				score += int(10 * difficulty_multiplier)

	score_label.text = "Score: " + str(score)

func _on_plant_despawned(obj, spawn_point, plant_type) -> void:
	occupied_points.erase(spawn_point)
	if plant_type == "grass" or plant_type == "branch":
		missed_weeds += 1
		if lives > 0:
			lives -= 1
		lives_label.text = "Lives: " + str(lives)
		if missed_weeds >= 3:
			game_over()

func game_over() -> void:
	spawn_timer.stop()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	end_panel.show()
	end_money_label.text = "Earned: " + str(score) + "$"
	if kytka_down:
		end_msg.text = "Try not to cut the flowers..."
		kytka_down = false
	else:
		end_msg.text = "Your hands fast, but weeds faster"

func _on_back_button_pressed() -> void:
	confirm_popup.show()

func _on_confirm_yes_button_pressed() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().change_scene_to_file("res://scenes/game.tscn")

func _on_confirm_no_button_pressed() -> void:
	confirm_popup.hide()

func _on_ok_button_pressed() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().change_scene_to_file("res://scenes/game.tscn")
	Global.money += score
	Global.worked_today = true
