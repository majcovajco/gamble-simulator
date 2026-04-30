extends Node

var money = 1000
var hunger = 3
var day = 1

@onready var player = get_node("/root/Game/player")
@onready var UI = %UI
@onready var death_screen = %UI/Death_screen

var worked_today = false
var hungry = false
var death_flag = false

func death():
	death_screen.visible = true
	player.set_physics_process(false)
	death_flag = true
	
func work():
	if worked_today == false:
		worked_today = true
		money += 500
		UI.update_money()

func sleep():
	worked_today = false
	day += 1
	hunger -= 1
	UI.update_money()
	UI.update_day()
	if hunger < 0:
		death()

func eat():
	if hunger < 3:
		hunger += 1
	elif hunger >= 3:
		player.apply_speed_boost(250, -300, 20.0)
	money -= 20
	UI.update_money()
	print(hunger)

func _on_money_label_ready() -> void:
	pass # Replace with function body.
