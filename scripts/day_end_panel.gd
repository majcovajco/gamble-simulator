extends ScrollContainer

@onready var sum_label = $BoxContainer/totalPanelContainer2/HBoxContainer/sum
@onready var rent_button = $BoxContainer/rent_box/HBoxContainer/RentCheckButton
@onready var electric_button = $BoxContainer/electricity_box/HBoxContainer/ElectricCheckButton
@onready var UI = %UI

signal sleep_confirmed

var sum = 0
var pay_processed = false

func _ready() -> void:
	sum_label.text = "                                        " + str(sum) + "$"

func reset_panel() -> void:
	pay_processed = false
	sum_label.text = "                                        " + str(sum) + "$"
	Global.is_homeless = false
	Global.has_electricity = false

func _on_rent_check_button_toggled(toggled_on: bool) -> void:
	if pay_processed:
		return

	if toggled_on:
		sum += 200
		Global.is_homeless = false
	else:
		sum -= 200
		Global.is_homeless = true

	sum_label.text = "                                        " + str(sum) + "$"

func _on_electric_check_button_toggled(toggled_on: bool) -> void:
	if pay_processed:
		return

	if toggled_on:
		sum += 50
		Global.has_electricity = true
	else:
		sum -= 50
		Global.has_electricity = false

	sum_label.text = "                                        " + str(sum) + "$"

func _on_pay_button_pressed() -> void:
	if pay_processed:
		return

	pay_processed = true
	Global.money -= sum
	UI.update_money()
	visible = false
	sleep_confirmed.emit()
