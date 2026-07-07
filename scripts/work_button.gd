extends TextureButton

@onready var UI = get_node("/root/Game/UI")

const HOVER_SCALE := 1.02
const PRESS_SCALE := 0.99
const HOVER_TINT := Color(1.08, 1.08, 1.08, 1.0)
const PRESS_TINT := Color(0.95, 0.95, 0.95, 1.0)

func _ready() -> void:
	pivot_offset = size * 0.5
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	button_down.connect(_on_button_down)
	button_up.connect(_on_button_up)

func _on_mouse_entered() -> void:
	scale = Vector2(HOVER_SCALE, HOVER_SCALE)
	modulate = HOVER_TINT

func _on_mouse_exited() -> void:
	scale = Vector2.ONE
	modulate = Color.WHITE

func _on_button_down() -> void:
	scale = Vector2(PRESS_SCALE, PRESS_SCALE)
	modulate = PRESS_TINT

func _on_button_up() -> void:
	if get_rect().has_point(get_local_mouse_position()):
		scale = Vector2(HOVER_SCALE, HOVER_SCALE)
		modulate = HOVER_TINT
	else:
		scale = Vector2.ONE
		modulate = Color.WHITE

func _on_gardener_pressed() -> void:
	UI.start_grass_cutter()
	
func _on_pizza_maker_pressed() -> void:
	UI.start_pizza_maker()

func _on_restaurant_work_pressed() -> void:
	UI.start_restaurant_game()
