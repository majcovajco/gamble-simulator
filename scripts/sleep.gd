extends Area2D

@onready var sleep_text = $Label
@onready var game_manager = %GameManager
var player_in_range = false
var panel_open = false
@onready var UI = %UI

func _ready():
	sleep_text.visible = false

func _on_body_entered(body):
	player_in_range = true
	sleep_text.visible = true

func _on_body_exited(body):
	sleep_text.visible = false
	player_in_range = false
	if panel_open:
		panel_open = false
		game_manager.hide_end_day_panel()

func _process(delta):
	if player_in_range and Input.is_action_just_pressed("interract"):
		if panel_open:
			panel_open = false
			game_manager.hide_end_day_panel()
		else:
			panel_open = true
			game_manager.sleep()
