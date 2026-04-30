extends Area2D

@onready var work_text = $work_label
@onready var game_manager = %GameManager
var player_in_range = false
@onready var UI = %UI

func _ready():
	work_text.visible = false

func _on_body_entered(body):
	work_text.visible = true
	player_in_range = true
	

func _on_body_exited(body):
	work_text.visible = false
	player_in_range = false
	
func _process(delta):
	if player_in_range and Input.is_action_just_pressed("interract") and game_manager.worked_today == false:
		game_manager.work()
		UI.fade()
