extends Control
class_name EnemyHUD

@export var full_heart_texture: Texture2D
@export var empty_heart_texture: Texture2D

@onready var hearts_parent: HBoxContainer = $HBoxContainer

var max_health := 0
var current_health := 0
var hearts: Array[TextureRect] = []

func setup(max_hp: int):
	max_health = max_hp
	current_health = max_hp
	
	if not is_inside_tree():
		await ready
	
	_create_hearts()
	update_display()

func set_health(value: int):
	current_health = clamp(value, 0, max_health)
	update_display()

func _create_hearts():
	for child in hearts_parent.get_children():
		child.queue_free()
	hearts.clear()

	for i in max_health:
		var heart := TextureRect.new()
		heart.texture = full_heart_texture
		heart.expand = true
		heart.custom_minimum_size = Vector2(32, 32)
		hearts_parent.add_child(heart)
		hearts.append(heart)

func update_display():
	for i in hearts.size():
		if i < current_health:
			hearts[i].texture = full_heart_texture
		else:
			hearts[i].texture = empty_heart_texture
