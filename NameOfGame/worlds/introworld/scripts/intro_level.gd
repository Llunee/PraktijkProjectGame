extends Node2D

@onready var save_manager := get_node("/root/SaveManager")
@onready var player := get_tree().get_first_node_in_group("player")
const SAVE_KEY := "mygame_save_v1"

func _ready():
	if save_exists():
		print("⏩ Save gevonden, terugladen...")
		save_manager.load_game(player)
		goto_saved_level()

func save_exists() -> bool:
	var json = JavaScriptBridge.eval("""localStorage.getItem("%s");""" % save_manager.SAVE_KEY)
	return json != null and json != ""
	
func goto_saved_level():
	var level_name = JSON.parse_string(JavaScriptBridge.eval("""localStorage.getItem("%s");""" % SAVE_KEY)).get("current_level", "intro_level")
	if level_name != get_tree().current_scene.name:
		get_tree().change_scene("res://levels/%s.tscn" % level_name)
