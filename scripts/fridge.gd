extends Area2D
@onready var fridge_text = $chladnicka_label
@onready var game_manager = %GameManager
var player_in_range = false

func _ready():
	fridge_text.visible = false

func _on_body_entered(body):
	fridge_text.visible = true
	player_in_range = true

func _on_body_exited(body):
	fridge_text.visible = false
	player_in_range = false
	
func _process(delta):
	if player_in_range and Input.is_action_just_pressed("interract"):
		game_manager.eat()
