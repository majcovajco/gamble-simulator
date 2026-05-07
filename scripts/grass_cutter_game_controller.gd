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

var score = 0
var lives = 3
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
	spawn_layer.add_child(obj)

func _on_plant_clicked(obj, spawn_point) -> void:
	occupied_points.erase(spawn_point)
	score += 10
	score_label.text = "Score: " + str(score)

func _on_back_button_pressed() -> void:
	confirm_popup.show()

func _on_confirm_yes_button_pressed() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().change_scene_to_file("res://scenes/game.tscn")

func _on_confirm_no_button_pressed() -> void:
	confirm_popup.hide()
