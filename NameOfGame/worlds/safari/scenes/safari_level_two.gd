extends Node2D

@export var gold_coin_scene: PackedScene
@export var red_coin_scene: PackedScene
@onready var gold_coin_spawn_points = $GoldCoinSpawns.get_children()
@onready var red_coin_spawn_points = $RedCoinSpawns.get_children()

func _ready() -> void:
	for gold_coin_marker in gold_coin_spawn_points:
		spawn_item(gold_coin_marker.global_position, gold_coin_scene)
	for red_coin_marker in red_coin_spawn_points:
		spawn_item(red_coin_marker.global_position, red_coin_scene)

func spawn_item(pos: Vector2, scene: PackedScene) -> void:
	var item = scene.instantiate()
	add_child(item)
	item.global_position = pos
	item.player = $Player
	item.connect("collected", Callable(self, "_on_item_collected").bind(scene))

func _on_item_collected(pos: Vector2, scene: PackedScene) -> void:
	var timer = get_tree().create_timer(5.0)
	await timer.timeout
	spawn_item(pos, scene)
