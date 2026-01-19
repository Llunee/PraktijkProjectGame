extends Node2D

@export var gold_coin_scene: PackedScene
@export var red_coin_scene: PackedScene

@onready var player = $Player
@onready var gold_coin_spawn_points = $GoldCoinSpawns.get_children()
@onready var red_coin_spawn_points = $RedCoinSpawns.get_children()
@onready var checkpoint = $Checkpoint
@onready var checkpoint_label = $CheckpointLabel
@onready var ice_area = $IceArea

var checkpoint_passed : bool = false
var is_on_ice = false
var ice_overlap_count := 0

func _ready() -> void:
	for gold_coin_marker in gold_coin_spawn_points:
		spawn_item(gold_coin_marker.global_position, gold_coin_scene)
	for red_coin_marker in red_coin_spawn_points:
		spawn_item(red_coin_marker.global_position, red_coin_scene)

func _process(delta : float):
	pass_checkpoint()

func pass_checkpoint():
	if checkpoint_passed:
		return
	if player.global_position.x >= checkpoint.global_position.x:
		checkpoint_passed = true
		SaveManager.save_game(player)
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


func _on_ice_area_body_entered(body: Node) -> void:
	if body != player:
		return
	ice_overlap_count += 1
	if ice_overlap_count == 1:
		PlayerData.is_on_ice()
		is_on_ice = true

func _on_ice_area_body_exited(body: Node) -> void:
	if body != player:
		return
	ice_overlap_count -= 1
	if ice_overlap_count <= 0:
		ice_overlap_count = 0
		PlayerData.is_off_ice()
		is_on_ice = false
