extends Node2D

@onready var start_button: Button = %start_button
@onready var continue_button: Button = %continue_button
@onready var settings_button: Button = %settings
@onready var save_manager := get_node("/root/SaveManager")

const SAVE_KEY := "mygame_save_v1"

var has_save := false
var level_paths_json : Dictionary

func _ready() -> void:
	read_json()
	has_save = save_exists()
	
	continue_button.visible = false
	continue_button.disabled = true

	if has_save:
		continue_button.visible = true
		continue_button.disabled = false

	start_button.pressed.connect(_on_start_button_pressed)
	#continue_button.pressed.connect(_on_continue_button_pressed)

func _unhandled_input(event):
	if event.is_action_pressed("start_game"):
		_on_start_button_pressed()

func _on_start_button_pressed():
	PlayerData.loaded_from_save = false
	get_tree().change_scene_to_file(
		"res://character-picker/scenes/character_picker.tscn"
	)

func save_exists() -> bool:
	var json = JavaScriptBridge.eval(
		"""localStorage.getItem("%s");""" % SAVE_KEY
	)
	return json != null and json != ""

func goto_saved_level():
	var json_string = JavaScriptBridge.eval("""localStorage.getItem("%s");""" % SAVE_KEY)
	var level_path = get_current_level_path(json_string)

	if level_path == "":
		return
	
	PlayerData.loaded_from_save = true
	get_tree().change_scene_to_file(level_path)

func read_json():
	var file = "res://logic/scripts/JSON/levels.json"
	var json_as_text = FileAccess.get_file_as_string(file)
	var parsed = JSON.parse_string(json_as_text)
	level_paths_json = parsed[0]

func get_current_level_path(json_save_data : String):
	var data = JSON.parse_string(json_save_data)
	if data == null:
		return ""

	var location = data.get("progress", {}).get("location", {})
	var world_index = int(location.get("world", 0))
	var level_index = int(location.get("level", 0)) - 1
	if level_index < 0:
		level_index = 0

	var world_map = ["safari", "sea", "ice", "jungle", "intro", "home"]
	var level_map = ["one", "two", "three"]

	if world_index >= world_map.size() or level_index >= level_map.size():
		return ""

	var world_name = world_map[world_index]
	var level_name = level_map[level_index]

	return level_paths_json.get(world_name, {}).get(level_name, "")

func _on_continue_button_pressed():
	if not has_save:
		return

	print("⏩ Save gevonden, laden...")
	goto_saved_level()
