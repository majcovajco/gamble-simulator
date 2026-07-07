extends Area2D

signal order_chosen(meal_name, customer)
signal customer_served(customer)
signal customer_left(customer, was_served)

const ORDER_TIME = 4.5
const LEAVE_DELAY = 2.4
const MEAL_OPTIONS = ["burger", "salad", "pizza"]

var spawn_point: Node = null
var order_name: String = ""
var current_state: String = "waiting"

@onready var timer: Timer = $Despawn_Timer
var order_label: Label

func _ready() -> void:
	add_to_group("customers")
	timer.one_shot = true
	timer.timeout.connect(_on_timer_timeout)
	timer.wait_time = ORDER_TIME
	timer.start()

	order_label = Label.new()
	order_label.name = "OrderLabel"
	order_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	order_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	order_label.position = Vector2(-40, -70)
	order_label.size = Vector2(80, 24)
	order_label.add_theme_font_size_override("font_size", 16)
	order_label.modulate = Color(1, 0.95, 0.3, 1)
	add_child(order_label)
	update_order_label()

func update_order_label() -> void:
	if order_label == null:
		return
	match current_state:
		"waiting":
			order_label.text = "?"
		"order_ready":
			order_label.text = order_name.to_upper()
		"served":
			order_label.text = "✓"
		_:
			order_label.text = ""

func _on_timer_timeout() -> void:
	match current_state:
		"waiting":
			order_name = MEAL_OPTIONS.pick_random()
			current_state = "order_ready"
			update_order_label()
			emit_signal("order_chosen", order_name, self)
			timer.wait_time = LEAVE_DELAY
			timer.start()
		"order_ready":
			emit_signal("customer_left", self, false)
			queue_free()
		"served":
			emit_signal("customer_left", self, true)
			queue_free()

func receive_meal(meal_name: String) -> bool:
	if current_state != "order_ready":
		return false

	if meal_name == order_name:
		current_state = "served"
		update_order_label()
		emit_signal("customer_served", self)
		timer.wait_time = 0.6
		timer.start()
		return true

	return false
