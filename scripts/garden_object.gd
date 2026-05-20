extends Area2D

signal plant_clicked(obj, spawn_point, plant_type)
signal plant_despawned(obj, spawn_point, plant_type)

var spawn_point: Marker2D = null

var current_difficulty = 1.0

var is_grown = false
var branch_hp = 3
var plant_type = "weed"
var textures = {
	"grass" : preload("res://assets/grass_grown.png"),
	"flower" : preload("res://assets/flower_icon.png"),
	"branch" : preload("res://assets/branch_icon.png")
}

func _ready() -> void:
	input_pickable = true
	connect("input_event", _on_input_event)
	
	$GrowthTimer.wait_time = max(0.5, 2.0 / current_difficulty)
	$GrowthTimer.connect("timeout", evolve_plant)
	$GrowthTimer.start()
	
	if has_node("DespawnTimer"):
		$DespawnTimer.wait_time = max(1.5, 4.0 / current_difficulty)
		$DespawnTimer.connect("timeout", _on_despawn_timer_timeout)
		$DespawnTimer.start()

func evolve_plant() -> void:
	if is_grown: return
	is_grown = true

	var r = randf()
	if r < 0.33:
		plant_type = "grass"
	elif r < 0.66:
		plant_type = "flower"
	else:
		plant_type = "branch"

	$Visual.texture = textures[plant_type]

func _on_input_event(_viewport, event, _shape_idx) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		
		# Logika pre konar - 3 kliknutia
		if plant_type == "branch":
			branch_hp -= 1
			if branch_hp > 0:
				# Ak ma stale HP nevysielame signal a funkciu tu ukoncime s return
				return 
				
		emit_signal("plant_clicked", self, spawn_point, plant_type)
		queue_free()

# Nova funkcia, ktora sa spusti po uplynuti DespawnTimer-a
func _on_despawn_timer_timeout() -> void:
	emit_signal("plant_despawned", self, spawn_point, plant_type)
	queue_free()
