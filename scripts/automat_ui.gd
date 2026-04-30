extends Control

@onready var valce = $monitor_png/casino_background/Slot_3x3
@onready var cells = valce.get_children()
@onready var bigbass = $monitor_png/casino_background
@onready var shop_background = $monitor_png/shop_background
@onready var game_manager = %GameManager
@onready var UI = %UI
@onready var amount_won = $monitor_png/casino_background/win_amount

var bet_array = [1, 5, 10, 20, 50, 100, 200, 500, 1000, 5000, 10000, 50000]
var current_multiplayer_index = 0
var win_multiplayer = bet_array[current_multiplayer_index]

var symbols = [
	"WORM", "HOOK", "SHELL",
	"CRAB", "TROUT", "PLAVAK", "ROD",
	"BIG_BASS"
]

var symbol_weights = {
	"WORM": 25,
	"HOOK": 19,
	"SHELL": 17,
	"CRAB": 14,
	"TROUT": 10,
	"PLAVAK": 8,
	"ROD": 6,
	"BIG_BASS": 1,
}

var symbol_textures = {
	"WORM": preload("res://symbols/worm.png"),
	"HOOK": preload("res://symbols/Hook.png"),
	"SHELL": preload("res://symbols/shell.png"),
	"CRAB": preload("res://symbols/crab.png"),
	"TROUT": preload("res://symbols/trout.png"),
	"PLAVAK": preload("res://symbols/plavak.png"),
	"ROD": preload("res://symbols/rod.png"),
	"BIG_BASS": preload("res://symbols/big_bass.png")
}

func get_weighted_symbol():
	var total = 0
	for w in symbol_weights.values():
		total += w
	
	var r = randf() * total
	var cumulative = 0
	
	for s in symbol_weights.keys():
		cumulative += symbol_weights[s]
		if r <= cumulative:
			return s

func spin():
	valce.show()
	# stopne všetky animácie
	for cell in cells:
		cell.stop_animation()
		
	for cell in cells:
		var s = get_weighted_symbol()
		cell.symbol = s
		cell.texture = symbol_textures[s]
		
var win_lines = [
	[0,1,2],
	[3,4,5],
	[6,7,8],
	[0,4,8],
	[6,4,2],
	[0,7,2],
	[6,1,8],
	[0,1,5],
	[3,4,2],
	[3,4,8],
	[6,7,5],
	[0,4,2],
	[6,4,8],
	[0,4,5],
	[3,1,2],
	[3,7,8],
	[6,4,5]
]

func win_check ():
	winning_cells = [] #inak by sme pridávali do nekonečna	
	var total = 0
	
	for line in win_lines:
		var a = cells[line[0]].symbol
		var b = cells[line[1]].symbol
		var c = cells[line[2]].symbol
		
		if a == b && b == c:
			print("VYRHA!!!!:", a)
			total += check_win_value(a)
			#vráti kumulatívnu výhru nie len jednu
			winning_cells.append(line)
			
	highlight_wins()
	#default ak nič nevyhrá
	return total
	
var winning_cells = []
#------------skopčené od chatu--------------------
func fake_spin():
	
	for i in range(10):
		await get_tree().create_timer(0.05).timeout
		
		for cell in cells:
			cell.texture = symbol_textures[symbols.pick_random()]
	
func highlight_wins():
	await animate_sequence_once()
	play_final_pulse()

func animate_sequence_once():
	for line in winning_cells:
		
		for i in line:
			var cell = cells[i]
			
			if cell.tween:
				cell.tween.kill()
			
			cell.tween = create_tween()
			cell.tween.tween_property(cell, "scale", Vector2(1.3,1.3), 0.15)
			cell.tween.tween_property(cell, "scale", Vector2(1,1), 0.15)
			
			await get_tree().create_timer(0.07).timeout
		
		# pauza medzi líniami
		await get_tree().create_timer(0.5).timeout
		
func play_final_pulse():
	var unique_cells = []

	for line in winning_cells:
		for i in line:
			if i not in unique_cells:
				unique_cells.append(i)

	for i in unique_cells:
		var cell = cells[i]
		
		if cell.tween:
			cell.tween.kill()
		
		cell.tween = create_tween()
		cell.tween.set_loops()
		
		cell.tween.tween_property(cell, "scale", Vector2(1.25,1.25), 0.2)
		cell.tween.tween_property(cell, "scale", Vector2(1,1), 0.2)
#-----------------------------------------------------------------

#multiplayer podľa vkladu
func check_win_value (symbol):
	if symbol == "WORM":
		return 0.42
	elif symbol == "HOOK":
		return 0.85
	elif symbol == "SHELL":
		return 1.7
	elif symbol == "CRAB":
		return 4.2
	elif symbol == "TROUT":
		return 8.5
	elif symbol == "PLAVAK":
		return 17
	elif symbol == "ROD":
		return 38
	elif symbol == "BIG_BASS":
		return 400

# stará sa o volanie pomocných funkcii a money updatovanie
func _on_spin_button_pressed() -> void:
	await fake_spin()
	spin()
	game_manager.money -= 1 * win_multiplayer
	UI.update_money()
	var vyhra = win_check()
	print("vyhral si:", vyhra)
	# zaokrúhlujeme lebo multiplayer je divoký
	game_manager.money += snapped((vyhra * win_multiplayer), 0.01)
	#upraví label win_amount a na koniec hodí žltý $ sing, zavlní sa pri výhre väčšej ako 5€
	if (vyhra * win_multiplayer) < 5:
		amount_won.text = "[color=white]" + str(vyhra * win_multiplayer) + "[/color][color=yellow]$[/color]"
	else:
		amount_won.text = "[wave] [color=white] " + str(vyhra * win_multiplayer) + "[/color][color=yellow]$[/color][/wave]"
	UI.update_money()
	valce.visible = true

func _on_exit_button_pressed() -> void:
	bigbass.hide()

func _on_shop_exit_button_pressed() -> void:
	shop_background.hide()

func _on_plus_button_pressed() -> void:
	if current_multiplayer_index < bet_array.size() - 1:
		current_multiplayer_index += 1
		win_multiplayer = bet_array[current_multiplayer_index]
		UI.update_bet()
	else:
		print("viac to už nejde")

func _on_minus_button_pressed() -> void:
	if current_multiplayer_index > 0:
		current_multiplayer_index -= 1
		win_multiplayer = bet_array[current_multiplayer_index]
		UI.update_bet()
	else:
		print("netrochárč")
