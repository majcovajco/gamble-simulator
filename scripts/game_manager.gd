extends Node

@onready var player = get_node("/root/Game/player")
@onready var UI = %UI
@onready var death_screen = %UI/Death_screen

var hungry = false
var death_flag = false

func death():
	death_screen.visible = true
	player.set_physics_process(false)
	death_flag = true
	
func work():
	if Global.worked_today == false:
		Global.worked_today = true
		Global.money += 500
		UI.update_money()

func sleep():
	Global.worked_today = false
	Global.day += 1
	Global.hunger -= 1
	UI.update_money()
	UI.update_day()
	if Global.hunger < 0:
		death()

func eat():
	if Global.hunger < 3:
		Global.hunger += 1
	elif Global.hunger >= 3:
		player.apply_speed_boost(250, -300, 20.0)
	Global.money -= 20
	UI.update_money()
	print(Global.hunger)

func _on_money_label_ready() -> void:
	pass # Replace with function body.
