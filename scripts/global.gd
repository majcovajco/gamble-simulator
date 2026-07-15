extends Node

var money = 1000
var hunger = 3
var day = 1
var worked_today = false
var is_evening = false
#----homeless & electricity flags----
var is_homeless = false
var has_electricity = true

var items = {
	"toaletak": { "base_price": 100, "current_price": 100 },
	"whisky": { "base_price": 300, "current_price": 300 },
	"dog_food": { "base_price": 250, "current_price": 250 },
	"cat_food": { "base_price": 200, "current_price": 200 },
	"katana": { "base_price": 20000, "current_price": 20000 },
	"armour": { "base_price": 25000, "current_price": 25000 }
}

var events = {
	"covid": {
		"msg": "Nová pandémia! Ľudia skupujú toaletný papier!",
		"modifiers": {
			"toaletak": 10.0, # Cena stúpne 10-násobne!
			"whisky": 1.5     # Ľudia pijú doma, cena mierne stúpne
		}
	},
	"zombie": {
		"msg": "Mesto je v karanténe!",
		"modifiers": {
			"toaletak": 1.5,
			"whisky": 2.0,
			"cat_food": 5.0 # Je nedostatok mäsa, žerie sa jedlo pre mačky
		}
	},
	"normal": {
		"msg": "Ďalší nudný deň na burze.",
		"modifiers": {} # Znamená, že ceny idú na normál
	}
}

# "owned" - number used for logic and operations
var luck_owned = 0
var toaletaky_owned = 0
var whisky_owned = 0
var dog_food_owned = 0
var cat_food_owned = 0
# Base "owned" trackers pre unikatne veci
var katana_owned = 0
var armour_owned = 0
