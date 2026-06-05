extends ScrollContainer
@onready var luck_price = $VBoxContainer/luck_container/HBoxContainer/VBoxContainer/HBoxContainer/item_price
@onready var toaletak_price_label = $VBoxContainer/toaletak_container/HBoxContainer/VBoxContainer/HBoxContainer/item_price
@onready var whisky_price_label = $VBoxContainer/whisky_container/HBoxContainer/VBoxContainer/HBoxContainer/item_price
@onready var dog_food_price_label = $VBoxContainer/dog_food_container/HBoxContainer/VBoxContainer/HBoxContainer/item_price
@onready var cat_food_price_label = $VBoxContainer/cat_food_container/HBoxContainer/VBoxContainer/HBoxContainer/item_price
@onready var katana_price_label = $VBoxContainer/katana_container/HBoxContainer/VBoxContainer/HBoxContainer/item_price
@onready var armour_price_label = $VBoxContainer/armour_container/HBoxContainer/VBoxContainer/HBoxContainer/item_price
@onready var UI = %UI
@onready var game_manager = %GameManager
@onready var luck_progress_bar = $VBoxContainer/luck_container/HBoxContainer/VBoxContainer/Luck_ProgressBar
#"amount" - used for actual representation for a player throug labels
@onready var toaletak_amount = $VBoxContainer/toaletak_container/HBoxContainer/VBoxContainer/toaletak_amount
@onready var whisky_amount = $VBoxContainer/whisky_container/HBoxContainer/VBoxContainer/whisky_amount
@onready var dog_food_amount = $VBoxContainer/dog_food_container/HBoxContainer/VBoxContainer/god_food_amount
@onready var cat_food_amount = $VBoxContainer/cat_food_container/HBoxContainer/VBoxContainer/cat_food_amount
#itemy ktoré sa budú postupne zobrazovať
@onready var katana = $"../../../../../bought_objects/katana"
@onready var armour = $"../../../../../bought_objects/armour"

@onready var cat_food = $"../../../../../bought_objects/macka_jedlo/cat_food"
@onready var cat_food2 = $"../../../../../bought_objects/macka_jedlo/cat_food2"
@onready var cat_food3 = $"../../../../../bought_objects/macka_jedlo/cat_food3"

@onready var dog_food = $"../../../../../bought_objects/psie_zradlo/dog_food"
@onready var dog_food2 = $"../../../../../bought_objects/psie_zradlo/dog_food2"
@onready var dog_food3 = $"../../../../../bought_objects/psie_zradlo/dog_food3"

@onready var toaletak = $"../../../../../bought_objects/toaletaky/toaletak"
@onready var toaletak2 = $"../../../../../bought_objects/toaletaky/toaletak2"
@onready var toaletak3 = $"../../../../../bought_objects/toaletaky/toaletak3"
@onready var toaletak4 = $"../../../../../bought_objects/toaletaky/toaletak4"
@onready var toaletak5 = $"../../../../../bought_objects/toaletaky/toaletak5"
@onready var toaletak6 = $"../../../../../bought_objects/toaletaky/toaletak6"
@onready var toaletak7 = $"../../../../../bought_objects/toaletaky/toaletak7"
@onready var toaletak8 = $"../../../../../bought_objects/toaletaky/toaletak8"
@onready var toaletak9 = $"../../../../../bought_objects/toaletaky/toaletak9"
@onready var toaletak10 = $"../../../../../bought_objects/toaletaky/toaletak10"

@onready var alko_skrinka = $"../../../../../bought_objects/alko_skrinka"
@onready var whisky = $"../../../../../bought_objects/alko_skrinka/whisky"
@onready var wine = $"../../../../../bought_objects/alko_skrinka/wine"
@onready var liquor = $"../../../../../bought_objects/alko_skrinka/liquor"
@onready var liquor2 = $"../../../../../bought_objects/alko_skrinka/liquor2"
@onready var liquor3 = $"../../../../../bought_objects/alko_skrinka/liquor3"
@onready var liquor4 = $"../../../../../bought_objects/alko_skrinka/liquor4"
@onready var whisky2 = $"../../../../../bought_objects/alko_skrinka/whisky2"
@onready var whisky3 = $"../../../../../bought_objects/alko_skrinka/whisky3"
@onready var wine2 = $"../../../../../bought_objects/alko_skrinka/wine2"

@onready var toaletak_sell_btn = $VBoxContainer/toaletak_container/HBoxContainer/VBoxContainer/HBoxContainer2/sell
@onready var whisky_sell_btn = $VBoxContainer/whisky_container/HBoxContainer/VBoxContainer/HBoxContainer2/sell
@onready var dog_food_sell_btn = $VBoxContainer/dog_food_container/HBoxContainer/VBoxContainer/HBoxContainer2/sell
@onready var cat_food_sell_btn = $VBoxContainer/cat_food_container/HBoxContainer/VBoxContainer/HBoxContainer2/sell
@onready var katana_sell_btn = $VBoxContainer/katana_container/HBoxContainer/VBoxContainer/HBoxContainer2/sell
@onready var armour_sell_btn = $VBoxContainer/armour_container/HBoxContainer/VBoxContainer/HBoxContainer2/sell

var luck_price_arr = [100, 150, 275, 450, 700, 1100, 1800, 3000, 4500, 7000]

func update_market_prices() -> void:
	if toaletak_price_label != null:
		toaletak_price_label.text = str(Global.items["toaletak"]["current_price"])
		whisky_price_label.text = str(Global.items["whisky"]["current_price"])
		dog_food_price_label.text = str(Global.items["dog_food"]["current_price"])
		cat_food_price_label.text = str(Global.items["cat_food"]["current_price"])
		katana_price_label.text = str(Global.items["katana"]["current_price"])
		armour_price_label.text = str(Global.items["armour"]["current_price"])

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	luck_price.text = str(luck_price_arr[Global.luck_owned])
	update_market_prices()
	update_market_tooltips()
	update_toaletak_visuals()
	toaletak_amount.text = str(Global.toaletaky_owned)
	whisky_amount.text = str(Global.whisky_owned)
	dog_food_amount.text = str(Global.dog_food_owned)
	cat_food_amount.text = str(Global.cat_food_owned)

	# Inicializácia ProgressBaru pre Luck
	luck_progress_bar.max_value = luck_price_arr.size()
	luck_progress_bar.value = Global.luck_owned

#--------- buy and sell logic & button bindings ------------

func update_toaletak_visuals() -> void:
	toaletak.hide()
	toaletak2.hide()
	toaletak3.hide()
	toaletak4.hide()
	toaletak5.hide()
	toaletak6.hide()
	toaletak7.hide()
	toaletak8.hide()
	toaletak9.hide()
	toaletak10.hide()
	
	if Global.toaletaky_owned > 9:
		toaletak.show(); toaletak2.show(); toaletak3.show(); toaletak4.show(); toaletak5.show(); toaletak6.show(); toaletak7.show(); toaletak8.show(); toaletak9.show(); toaletak10.show()
	elif Global.toaletaky_owned > 8:
		toaletak.show(); toaletak2.show(); toaletak3.show(); toaletak4.show(); toaletak5.show(); toaletak6.show(); toaletak7.show(); toaletak8.show(); toaletak9.show()
	elif Global.toaletaky_owned > 7:
		toaletak.show(); toaletak2.show(); toaletak3.show(); toaletak4.show(); toaletak5.show(); toaletak6.show(); toaletak7.show(); toaletak8.show()
	elif Global.toaletaky_owned > 6:
		toaletak.show(); toaletak2.show(); toaletak3.show(); toaletak4.show(); toaletak5.show(); toaletak6.show(); toaletak7.show()
	elif Global.toaletaky_owned > 5:
		toaletak.show(); toaletak2.show(); toaletak3.show(); toaletak4.show(); toaletak5.show(); toaletak6.show()
	elif Global.toaletaky_owned > 4:
		toaletak.show(); toaletak2.show(); toaletak3.show(); toaletak4.show(); toaletak5.show()
	elif Global.toaletaky_owned > 3:
		toaletak.show(); toaletak2.show(); toaletak3.show(); toaletak4.show()
	elif Global.toaletaky_owned > 2:
		toaletak.show(); toaletak2.show(); toaletak3.show()
	elif Global.toaletaky_owned > 1:
		toaletak.show(); toaletak2.show()
	elif Global.toaletaky_owned > 0:
		toaletak.show()

func update_whisky_visuals() -> void:
	alko_skrinka.hide()
	whisky.hide()
	wine.hide()
	liquor.hide()
	liquor2.hide()
	liquor3.hide()
	liquor4.hide()
	whisky2.hide()
	whisky3.hide()
	wine2.hide()
	
	if Global.whisky_owned > 8:
		alko_skrinka.show(); whisky.show(); wine.show(); liquor.show(); liquor2.show(); liquor3.show(); liquor4.show(); whisky2.show(); whisky3.show(); wine2.show()
	elif Global.whisky_owned > 7:
		alko_skrinka.show(); whisky.show(); wine.show(); liquor.show(); liquor2.show(); liquor3.show(); liquor4.show(); whisky2.show(); whisky3.show()
	elif Global.whisky_owned > 6:
		alko_skrinka.show(); whisky.show(); wine.show(); liquor.show(); liquor2.show(); liquor3.show(); liquor4.show(); whisky2.show()
	elif Global.whisky_owned > 5:
		alko_skrinka.show(); whisky.show(); wine.show(); liquor.show(); liquor2.show(); liquor3.show(); liquor4.show()
	elif Global.whisky_owned > 4:
		alko_skrinka.show(); whisky.show(); wine.show(); liquor.show(); liquor2.show(); liquor3.show()
	elif Global.whisky_owned > 3:
		alko_skrinka.show(); whisky.show(); wine.show(); liquor.show(); liquor2.show()
	elif Global.whisky_owned > 2:
		alko_skrinka.show(); whisky.show(); wine.show(); liquor.show()
	elif Global.whisky_owned > 1:
		alko_skrinka.show(); whisky.show(); wine.show()
	elif Global.whisky_owned > 0:
		alko_skrinka.show(); whisky.show()

func update_dog_food_visuals() -> void:
	dog_food.hide()
	dog_food2.hide()
	dog_food3.hide()
	
	if Global.dog_food_owned >= 20:
		dog_food.show()
		dog_food2.show()
		dog_food3.show()
	elif Global.dog_food_owned >= 5:
		dog_food.show()
		dog_food2.show()
	elif Global.dog_food_owned > 0:
		dog_food.show()

func update_cat_food_visuals() -> void:
	cat_food.hide()
	cat_food2.hide()
	cat_food3.hide()
	
	if Global.cat_food_owned >= 20:
		cat_food.show()
		cat_food2.show()
		cat_food3.show()
	elif Global.cat_food_owned >= 5:
		cat_food.show()
		cat_food2.show()
	elif Global.cat_food_owned > 0:
		cat_food.show()

#--------- logic behind UI itmes showing ------------
#------TOALETAK---------
func _toaletak_buy_pressed() -> void:
	if Global.toaletaky_owned < 1000:# and game_manager.money >= toaletak_current_price:
		Global.money -= Global.items["toaletak"]["current_price"]
		Global.toaletaky_owned += 1
		toaletak_amount.text = str(Global.toaletaky_owned)
		update_toaletak_visuals() # Vol�me na�u funkciu na aktualiz�ciu obr�zkov
		UI.update_money()

func _toaletak_sell_pressed() -> void:
	if Global.toaletaky_owned > 0:
		# v�dy pred� jemne pod cenu trhu (napr. 90% nesk�r uprav�m)
		var sell_price = int(Global.items["toaletak"]["current_price"] * 0.95)
		Global.money += sell_price
		Global.toaletaky_owned -= 1
		toaletak_amount.text = str(Global.toaletaky_owned)
		update_toaletak_visuals()
		UI.update_money()

#------LUCK---------
func _luck_buy_pressed() -> void:
	if Global.luck_owned < luck_price_arr.size():
		Global.money -= luck_price_arr[Global.luck_owned]
		Global.luck_owned += 1
		UI.update_money()
		#Aktualizuje Luck_Progress_Bar!!!
		luck_progress_bar.value = Global.luck_owned
		if Global.luck_owned < luck_price_arr.size():
			luck_price.text = str(luck_price_arr[Global.luck_owned])
		else:
			luck_price.text = "MAX"

#------WHISKY---------
func _whisky_buy_pressed() -> void:
	if Global.whisky_owned < 1000:# and game_manager.money >= whisky_current_price:
		Global.money -= Global.items["whisky"]["current_price"]
		Global.whisky_owned += 1
		whisky_amount.text = str(Global.whisky_owned)
		update_whisky_visuals()
		UI.update_money()

func _whisky_sell_pressed() -> void:
	if Global.whisky_owned > 0:
		var sell_price = int(Global.items["whisky"]["current_price"] * 0.95)
		Global.money += sell_price
		Global.whisky_owned -= 1
		whisky_amount.text = str(Global.whisky_owned)
		update_whisky_visuals()
		UI.update_money()

#------DOG FOOD---------
func dog_food_buy_pressed() -> void:
	if Global.dog_food_owned < 1000:# and game_manager.money >= dog_food_current_price:
		Global.money -= Global.items["dog_food"]["current_price"]
		Global.dog_food_owned += 1
		dog_food_amount.text = str(Global.dog_food_owned)
		update_dog_food_visuals()
		UI.update_money()

func _dog_food_sell_pressed() -> void:
	if Global.dog_food_owned > 0:
		var sell_price = int(Global.items["dog_food"]["current_price"] * 0.95)
		Global.money += sell_price
		Global.dog_food_owned -= 1
		dog_food_amount.text = str(Global.dog_food_owned)
		update_dog_food_visuals()
		UI.update_money()

#------CAT FOOD---------
func _cat_food_buy_pressed() -> void:
	if Global.cat_food_owned < 1000:# and game_manager.money >= cat_food_current_price:
		Global.money -= Global.items["cat_food"]["current_price"]
		Global.cat_food_owned += 1
		cat_food_amount.text = str(Global.cat_food_owned)
		update_cat_food_visuals()
		UI.update_money()

func _cat_food_sell_pressed() -> void:
	if Global.cat_food_owned > 0:
		var sell_price = int(Global.items["cat_food"]["current_price"] * 0.95)
		Global.money += sell_price
		Global.cat_food_owned -= 1
		cat_food_amount.text = str(Global.cat_food_owned)
		update_cat_food_visuals()
		UI.update_money()

#------KATANA---------
func _katana_buy_pressed() -> void:
	if Global.katana_owned == 0:# and game_manager.money >= katana_current_price:
		Global.money -= Global.items["katana"]["current_price"]
		Global.katana_owned = 1
		UI.update_money()
		katana.show()

func _katana_sell_pressed() -> void:
	if Global.katana_owned == 1:
		var sell_price = int(Global.items["katana"]["current_price"] * 0.9) # Luxus pad� r�chlej�ie
		Global.money += sell_price
		Global.katana_owned = 0
		katana.hide()
		UI.update_money()

#------ARMOUR---------
func _armour_buy_pressed() -> void:
	if Global.armour_owned == 0:# and game_manager.money >= armour_current_price:
		Global.money -= Global.items["armour"]["current_price"]
		Global.armour_owned = 1
		UI.update_money()
		armour.show()

func _armour_sell_pressed() -> void:
	if Global.armour_owned == 1:
		var sell_price = int(Global.items["armour"]["current_price"] * 0.8)
		Global.money += sell_price
		Global.armour_owned = 0
		armour.hide()
		UI.update_money()
	
#----------Hover nad sell buttonami pre nápovedu------------
func get_sell_tooltip(current_price: int, base_price: int, margin: float) -> String:
	var sell_price = int(current_price * margin)
	var text = "Sell for " + str(sell_price) + "$\n"
	
	if sell_price < base_price:
		text += "Market always wins..."
	else:
		text += "Almost a businessman!"
		
	return text
	
#funkciu vola� v�dy, ke� sa zmenia ceny na trhu (a aj raz v _ready()):
func update_market_tooltips() -> void:
	# (Aktu�lna cena, P�vodn� hodnota, Mar�a/Zr�ka)
	toaletak_sell_btn.tooltip_text = get_sell_tooltip(Global.items["toaletak"]["current_price"], 100, 0.95)
	whisky_sell_btn.tooltip_text = get_sell_tooltip(Global.items["whisky"]["current_price"], 100, 0.95)
	dog_food_sell_btn.tooltip_text = get_sell_tooltip(Global.items["dog_food"]["current_price"], 100, 0.95)
	cat_food_sell_btn.tooltip_text = get_sell_tooltip(Global.items["cat_food"]["current_price"], 100, 0.95)
	katana_sell_btn.tooltip_text = get_sell_tooltip(Global.items["katana"]["current_price"], 100, 0.95)
	armour_sell_btn.tooltip_text = get_sell_tooltip(Global.items["armour"]["current_price"], 100, 0.95)
