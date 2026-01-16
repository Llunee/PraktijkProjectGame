extends Node

const SAVE_KEY := "mygame_save_v1"

@onready var player_data := get_node("/root/PlayerData")
@onready var progress := get_node("/root/LevelData")

func _ready():
	player_data.connect("coins_updated", _autosave)
	progress.connect("progress_updated", _autosave)

func _autosave():
	var player = get_tree().get_first_node_in_group("player")
	if player:
		save_game(player)

func save_game(player_node: Node2D) -> void:
	if player_node == null:
		push_error("SaveManager: player_node is null")
		return

	var save_data := {
		"version": 1,
		"player": player_data.to_dict(player_node.global_position),
		"progress": progress.to_dict()
	}

	var json := JSON.stringify(save_data)

	JavaScriptBridge.eval("""
		localStorage.setItem("%s", `%s`);
	""" % [SAVE_KEY, json])

	print("✅ Game saved")

func load_game(player_node: Node2D) -> bool:
	if player_node == null:
		push_error("SaveManager: player_node is null")
		return false

	var json = JavaScriptBridge.eval("""
		localStorage.getItem("%s");
	""" % SAVE_KEY)

	if json == null:
		print("ℹ️ No save found")
		return false
	
	var data = JSON.parse_string(json)
	if data == null:
		push_error("❌ Save data corrupted")
		return false

	player_data.from_dict(data.get("player", {}), player_node)
	progress.from_dict(data.get("progress", {}))

	print("✅ Game loaded")
	return true

func load_after_scene_change():
	await get_tree().process_frame

	var player = get_tree().get_first_node_in_group("player")
	if player == null:
		push_error("SaveManager: Player not found after scene load")
		return

	load_game(player)
