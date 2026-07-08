extends CharacterBody2D

const SPEED = 700.0
const INTERACT_RANGE = 90.0

@onready var sprite: AnimatedSprite2D = $AnimatedSprite
@onready var held_sprite: Sprite2D = $HeldMeal

var carried_meal_name: String = ""

func _ready() -> void:
	_ensure_input_actions()
	if held_sprite != null:
		held_sprite.top_level = true
	_update_held_visual()

func _ensure_input_actions() -> void:
	var bindings: Dictionary = {
		"move_up": [KEY_W, KEY_UP],
		"move_down": [KEY_S, KEY_DOWN],
		"move_left": [KEY_A, KEY_LEFT],
		"move_right": [KEY_D, KEY_RIGHT],
		"interact": [KEY_E, KEY_ENTER, KEY_SPACE, KEY_KP_ENTER]
	}
	for action in bindings.keys():
		if not InputMap.has_action(action):
			InputMap.add_action(action)
		for key in bindings[action]:
			var exists := false
			for event in InputMap.action_get_events(action):
				if event is InputEventKey and event.physical_keycode == key:
					exists = true
				break
			if exists:
				continue
			var key_event := InputEventKey.new()
			key_event.physical_keycode = key
			key_event.keycode = key
			InputMap.action_add_event(action, key_event)

func _get_strength(name: String, fallback: Array = []) -> float:
	if InputMap.has_action(name):
		return Input.get_action_strength(name)
	for f in fallback:
		if InputMap.has_action(f):
			return Input.get_action_strength(f)
	return 0.0

func _action_just_pressed(name: String, fallback: Array = []) -> bool:
	if InputMap.has_action(name):
		return Input.is_action_just_pressed(name)
	for f in fallback:
		if InputMap.has_action(f):
			return Input.is_action_just_pressed(f)
	return false

func _update_held_visual() -> void:
	if held_sprite == null:
		return
	if carried_meal_name == "":
		held_sprite.visible = false
		return
	held_sprite.visible = true
	held_sprite.global_position = global_position + Vector2(0, -36)
	held_sprite.scale = Vector2(0.09, 0.09)
	match carried_meal_name:
		"burger":
			held_sprite.texture = load("res://assets/burger.png")
		"salad":
			held_sprite.texture = load("res://assets/salad.png")
		"pizza":
			held_sprite.texture = load("res://assets/pizza_slice.png")
		_:
			held_sprite.visible = false

func _physics_process(_delta: float) -> void:
	var direction := Vector2(
		_get_strength("move_right", ["ui_right"]) - _get_strength("move_left", ["ui_left"]),
		_get_strength("move_down", ["ui_down"]) - _get_strength("move_up", ["ui_up"])
	)

	if direction.length() > 0.0:
		direction = direction.normalized()
		velocity = direction * SPEED
		if abs(direction.x) > abs(direction.y):
			sprite.play("walk_right")
			sprite.flip_h = direction.x < 0
		else:
			sprite.play("walk_right")
	else:
		velocity = Vector2.ZERO
		sprite.play("stand")

	move_and_slide()
	_update_held_visual()

	# Keep player inside the walkable floor area of the restaurant scene.
	var vp = get_viewport().get_visible_rect()
	var left: float = 80.0
	var right: float = vp.size.x - 80.0
	var top: float = 120.0
	var bottom: float = vp.size.y - 60.0
	global_position.x = clamp(global_position.x, left, right)
	global_position.y = clamp(global_position.y, top, bottom)

func _process(_delta: float) -> void:
	var interact_pressed := _action_just_pressed("interact", ["interract", "ui_accept"]) or _action_just_pressed("ui_accept")
	if interact_pressed:
		if carried_meal_name == "":
			pick_up_nearest_meal()
		else:
			deliver_to_nearest_customer()

func pick_up_nearest_meal() -> void:
	if carried_meal_name != "":
		return

	var nearest_meal: Node = null
	var best_distance: float = INF

	for meal in get_tree().get_nodes_in_group("meals"):
		var dist = global_position.distance_to(meal.global_position)
		if dist <= INTERACT_RANGE and dist < best_distance:
			best_distance = dist
			nearest_meal = meal

	if nearest_meal != null:
		carried_meal_name = nearest_meal.meal_name
		nearest_meal.queue_free()
		_update_held_visual()

func deliver_to_nearest_customer() -> void:
	var nearest_customer: Node = null
	var best_distance: float = INF

	for customer in get_tree().get_nodes_in_group("customers"):
		var dist = global_position.distance_to(customer.global_position)
		if dist <= INTERACT_RANGE and dist < best_distance:
			best_distance = dist
			nearest_customer = customer

	if nearest_customer != null and nearest_customer.has_method("receive_meal"):
		if nearest_customer.receive_meal(carried_meal_name):
			carried_meal_name = ""
			_update_held_visual()
