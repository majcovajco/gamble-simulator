extends Area2D

signal plant_clicked(obj, spawn_point)

var spawn_point: Marker2D = null

# Predpríprava pre evolúciu (bude aktivované neskôr)
var is_grown = false
var plant_type = "weed" # typy: weed, grass, flower, branch

func _ready() -> void:
	input_pickable = true
	connect("input_event", _on_input_event)
	
	# Tu neskôr pridáme zapnutie Timeru pre evolúciu:
	# $GrowthTimer.start()

# Funkcia, ktorá sa zavolá po nejakej dobe (napr. cez Timer timeout)
func evolve_plant() -> void:
	if is_grown: return
	is_grown = true
	
	var r = randf()
	if r < 0.33:
		plant_type = "grass"
		# $Visual.texture = preload("res://assets/grass_grown.png")
	elif r < 0.66:
		plant_type = "flower"
		# $Visual.texture = preload("res://assets/flower.png")
	else:
		plant_type = "branch"
		# $Visual.texture = preload("res://assets/branch.png")
		
func _on_input_event(_viewport, event, _shape_idx) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		# Tu môžeme neskôr riešiť body podľa plant_type (napr. flower dajú viac bodov, branch ťa zraní atď.)
		emit_signal("plant_clicked", self, spawn_point)
		queue_free()
