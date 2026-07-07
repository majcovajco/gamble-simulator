extends Area2D

signal meal_collected(spawn_point)

var meal_name: String = "meal"
var spawn_point: Node = null

@onready var sprite: Sprite2D = $Sprite2D

func _ready() -> void:
	add_to_group("meals")
	connect("tree_exited", _on_tree_exited)
	update_visual()

func update_visual() -> void:
	if sprite == null:
		return
	match meal_name:
		"burger":
			sprite.texture = load("res://assets/burger.png")
		"salad":
			sprite.texture = load("res://assets/salad.png")
		"pizza":
			sprite.texture = load("res://assets/pizza_slice.png")
		_:
			sprite.texture = load("res://assets/burger.png")

func _on_tree_exited() -> void:
	if spawn_point != null:
		emit_signal("meal_collected", spawn_point)
