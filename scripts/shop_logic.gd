extends ScrollContainer
@onready var luck_price = $VBoxContainer/luck_container/HBoxContainer/VBoxContainer/HBoxContainer/item_price
@onready var toaletak_price = $VBoxContainer/toaletak_container/HBoxContainer/VBoxContainer/HBoxContainer/item_price
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

# "owned" - number used for logic and operations
var luck_owned = 0
var toaletaky_owned = 0
var whisky_owned = 0
var dog_food_owned = 0
var cat_food_owned = 0

# Base "owned" trackers pre unikatne veci
var katana_owned = 0
var armour_owned = 0

# Aktuálne trhové ceny (Neskôr sa budú dať meniť podľa udalostí vo svete)
var toaletak_current_price = 100
var whisky_current_price = 300
var dog_food_current_price = 250
var cat_food_current_price = 200
var katana_current_price = 20000
var armour_current_price = 25000

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	luck_price.text = str(luck_price_arr[luck_owned])
	toaletak_price.text = str(100)
	update_market_tooltips()
	#toaletak_amount.text = str(toaletaky_owned)
	
	# Inicializácia ProgressBaru pre Luck
	luck_progress_bar.max_value = luck_price_arr.size()
	luck_progress_bar.value = luck_owned

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
	
	if toaletaky_owned > 9:
		toaletak.show(); toaletak2.show(); toaletak3.show(); toaletak4.show(); toaletak5.show(); toaletak6.show(); toaletak7.show(); toaletak8.show(); toaletak9.show(); toaletak10.show()
	elif toaletaky_owned > 8:
		toaletak.show(); toaletak2.show(); toaletak3.show(); toaletak4.show(); toaletak5.show(); toaletak6.show(); toaletak7.show(); toaletak8.show(); toaletak9.show()
	elif toaletaky_owned > 7:
		toaletak.show(); toaletak2.show(); toaletak3.show(); toaletak4.show(); toaletak5.show(); toaletak6.show(); toaletak7.show(); toaletak8.show()
	elif toaletaky_owned > 6:
		toaletak.show(); toaletak2.show(); toaletak3.show(); toaletak4.show(); toaletak5.show(); toaletak6.show(); toaletak7.show()
	elif toaletaky_owned > 5:
		toaletak.show(); toaletak2.show(); toaletak3.show(); toaletak4.show(); toaletak5.show(); toaletak6.show()
	elif toaletaky_owned > 4:
		toaletak.show(); toaletak2.show(); toaletak3.show(); toaletak4.show(); toaletak5.show()
	elif toaletaky_owned > 3:
		toaletak.show(); toaletak2.show(); toaletak3.show(); toaletak4.show()
	elif toaletaky_owned > 2:
		toaletak.show(); toaletak2.show(); toaletak3.show()
	elif toaletaky_owned > 1:
		toaletak.show(); toaletak2.show()
	elif toaletaky_owned > 0:
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
	
	if whisky_owned > 8:
		alko_skrinka.show(); whisky.show(); wine.show(); liquor.show(); liquor2.show(); liquor3.show(); liquor4.show(); whisky2.show(); whisky3.show(); wine2.show()
	elif whisky_owned > 7:
		alko_skrinka.show(); whisky.show(); wine.show(); liquor.show(); liquor2.show(); liquor3.show(); liquor4.show(); whisky2.show(); whisky3.show()
	elif whisky_owned > 6:
		alko_skrinka.show(); whisky.show(); wine.show(); liquor.show(); liquor2.show(); liquor3.show(); liquor4.show(); whisky2.show()
	elif whisky_owned > 5:
		alko_skrinka.show(); whisky.show(); wine.show(); liquor.show(); liquor2.show(); liquor3.show(); liquor4.show()
	elif whisky_owned > 4:
		alko_skrinka.show(); whisky.show(); wine.show(); liquor.show(); liquor2.show(); liquor3.show()
	elif whisky_owned > 3:
		alko_skrinka.show(); whisky.show(); wine.show(); liquor.show(); liquor2.show()
	elif whisky_owned > 2:
		alko_skrinka.show(); whisky.show(); wine.show(); liquor.show()
	elif whisky_owned > 1:
		alko_skrinka.show(); whisky.show(); wine.show()
	elif whisky_owned > 0:
		alko_skrinka.show(); whisky.show()

func update_dog_food_visuals() -> void:
	dog_food.hide()
	dog_food2.hide()
	dog_food3.hide()
	
	if dog_food_owned >= 20:
		dog_food.show()
		dog_food2.show()
		dog_food3.show()
	elif dog_food_owned >= 5:
		dog_food.show()
		dog_food2.show()
	elif dog_food_owned > 0:
		dog_food.show()

func update_cat_food_visuals() -> void:
	cat_food.hide()
	cat_food2.hide()
	cat_food3.hide()
	
	if cat_food_owned >= 20:
		cat_food.show()
		cat_food2.show()
		cat_food3.show()
	elif cat_food_owned >= 5:
		cat_food.show()
		cat_food2.show()
	elif cat_food_owned > 0:
		cat_food.show()

#--------- logic behind UI itmes showing ------------
#------TOALETAK---------
func _toaletak_buy_pressed() -> void:
	if toaletaky_owned < 1000:# and game_manager.money >= toaletak_current_price:
		game_manager.money -= toaletak_current_price
		toaletaky_owned += 1
		toaletak_amount.text = str(toaletaky_owned)
		update_toaletak_visuals() # Voláme našu funkciu na aktualizáciu obrázkov
		UI.update_money()

func _toaletak_sell_pressed() -> void:
	if toaletaky_owned > 0:
		# vždy predáš jemne pod cenu trhu (napr. 90% neskôr upravím)
		var sell_price = int(toaletak_current_price * 0.95)
		game_manager.money += sell_price
		toaletaky_owned -= 1
		toaletak_amount.text = str(toaletaky_owned)
		update_toaletak_visuals()
		UI.update_money()

#------LUCK---------
func _luck_buy_pressed() -> void:
	if luck_owned < luck_price_arr.size():
		game_manager.money -= luck_price_arr[luck_owned]
		luck_owned += 1
		UI.update_money()
		#Aktualizuje Luck_Progress_Bar!!!
		luck_progress_bar.value = luck_owned
		if luck_owned < luck_price_arr.size():
			luck_price.text = str(luck_price_arr[luck_owned])
		else:
			luck_price.text = "MAX"

#------WHISKY---------
func _whisky_buy_pressed() -> void:
	if whisky_owned < 1000:# and game_manager.money >= whisky_current_price:
		game_manager.money -= whisky_current_price
		whisky_owned += 1
		whisky_amount.text = str(whisky_owned)
		update_whisky_visuals()
		UI.update_money()

func _whisky_sell_pressed() -> void:
	if whisky_owned > 0:
		var sell_price = int(whisky_current_price * 0.95)
		game_manager.money += sell_price
		whisky_owned -= 1
		whisky_amount.text = str(whisky_owned)
		update_whisky_visuals()
		UI.update_money()

#------DOG FOOD---------
func dog_food_buy_pressed() -> void:
	if dog_food_owned < 1000:# and game_manager.money >= dog_food_current_price:
		game_manager.money -= dog_food_current_price
		dog_food_owned += 1
		dog_food_amount.text = str(dog_food_owned)
		update_dog_food_visuals()
		UI.update_money()

func _dog_food_sell_pressed() -> void:
	if dog_food_owned > 0:
		var sell_price = int(dog_food_current_price * 0.95)
		game_manager.money += sell_price
		dog_food_owned -= 1
		dog_food_amount.text = str(dog_food_owned)
		update_dog_food_visuals()
		UI.update_money()

#------CAT FOOD---------
func _cat_food_buy_pressed() -> void:
	if cat_food_owned < 1000:# and game_manager.money >= cat_food_current_price:
		game_manager.money -= cat_food_current_price
		cat_food_owned += 1
		cat_food_amount.text = str(cat_food_owned)
		update_cat_food_visuals()
		UI.update_money()

func _cat_food_sell_pressed() -> void:
	if cat_food_owned > 0:
		var sell_price = int(cat_food_current_price * 0.95)
		game_manager.money += sell_price
		cat_food_owned -= 1
		cat_food_amount.text = str(cat_food_owned)
		update_cat_food_visuals()
		UI.update_money()

#------KATANA---------
func _katana_buy_pressed() -> void:
	if katana_owned == 0:# and game_manager.money >= katana_current_price:
		game_manager.money -= katana_current_price
		katana_owned = 1
		UI.update_money()
		katana.show()

func _katana_sell_pressed() -> void:
	if katana_owned == 1:
		var sell_price = int(katana_current_price * 0.9) # Luxus padá rýchlejšie
		game_manager.money += sell_price
		katana_owned = 0
		katana.hide()
		UI.update_money()

#------ARMOUR---------
func _armour_buy_pressed() -> void:
	if armour_owned == 0:# and game_manager.money >= armour_current_price:
		game_manager.money -= armour_current_price
		armour_owned = 1
		UI.update_money()
		armour.show()

func _armour_sell_pressed() -> void:
	if armour_owned == 1:
		var sell_price = int(armour_current_price * 0.8)
		game_manager.money += sell_price
		armour_owned = 0
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
	
#funkciu volať vždy, keď sa zmenia ceny na trhu (a aj raz v _ready()):
func update_market_tooltips() -> void:
	# (Aktuálna cena, Pôvodná hodnota, Marža/Zrážka)
	toaletak_sell_btn.tooltip_text = get_sell_tooltip(toaletak_current_price, 100, 0.95)
	whisky_sell_btn.tooltip_text = get_sell_tooltip(whisky_current_price, 100, 0.95)
	dog_food_sell_btn.tooltip_text = get_sell_tooltip(dog_food_current_price, 100, 0.95)
	cat_food_sell_btn.tooltip_text = get_sell_tooltip(cat_food_current_price, 100, 0.95)
	katana_sell_btn.tooltip_text = get_sell_tooltip(katana_current_price, 100, 0.95)
	armour_sell_btn.tooltip_text = get_sell_tooltip(armour_current_price, 100, 0.95)
