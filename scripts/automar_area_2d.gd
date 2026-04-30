extends Area2D
@onready var E = $Automat_tvar/E
@onready var UI = get_node("/root/Game/UI")
var player_in_range = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	E.visible = false

func _on_body_entered(body):
	player_in_range = true
	E.visible = true
	
func _on_body_exited(body):
	E.visible = false
	player_in_range = false
	
func _process(delta):
	if player_in_range and Input.is_action_just_pressed("interract"):
		UI.open_monitor()
