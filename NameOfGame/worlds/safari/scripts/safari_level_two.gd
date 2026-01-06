extends Node2D

@export var gold_coin_scene: PackedScene
@export var red_coin_scene: PackedScene

@onready var player = $Player
@onready var gold_coin_spawn_points = $GoldCoinSpawns.get_children()
@onready var red_coin_spawn_points = $RedCoinSpawns.get_children()
@onready var checkpoint = $Checkpoint
@onready var checkpoint_label = $CheckpointLabel

var checkpoint_passed : bool = false

func _ready() -> void:
	LevelData.update_level_progress(LevelData.Worlds.SAFARI)
	for gold_coin_marker in gold_coin_spawn_points:
		spawn_item(gold_coin_marker.global_position, gold_coin_scene)
	for red_coin_marker in red_coin_spawn_points:
		spawn_item(red_coin_marker.global_position, red_coin_scene)

func _process(delta : float):
	if checkpoint_passed:
		return
	if player.global_position.x >= checkpoint.global_position.x:
		checkpoint_passed = true
		player.update_respawn_location(checkpoint.global_position)
		checkpoint_label.text = "[wave amp=50.0 freq=5.0 connected=1]Checkpoint![/wave]"
		checkpoint_label.visible = true
		await get_tree().create_timer(5).timeout
		checkpoint_label.visible = false

func spawn_item(pos: Vector2, scene: PackedScene) -> void:
	var item = scene.instantiate()
	add_child(item)
	item.global_position = pos
	item.player = $Player
