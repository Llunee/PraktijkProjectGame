extends Node2D

@onready var start_button: Button = %start_button
@onready var continue_button: Button = %continue_button
@onready var settings_button: Button = %settings
@onready var save_manager := get_node("/root/SaveManager")

const SAVE_KEY := "mygame_save_v1"

var has_save := false

func _ready() -> void:
	has_save = save_exists()
	
	continue_button.visible = false
	continue_button.disabled = true

	if has_save:
		continue_button.visible = true
		continue_button.disabled = false

	start_button.pressed.connect(_on_start_button_pressed)
	continue_button.pressed.connect(_on_continue_button_pressed)

func _unhandled_input(event):
	if event.is_action_pressed("start_game"):
		_on_start_button_pressed()

func _on_start_button_pressed():
	if has_save:
		print("⏩ Save gevonden, laden...")
		goto_saved_level()
	else:
		get_tree().change_scene_to_file(
			"res://character-picker/scenes/character_picker.tscn"
		)

func save_exists() -> bool:
	var json = JavaScriptBridge.eval(
		"""localStorage.getItem("%s");""" % SAVE_KEY
	)
	return json != null and json != ""

func goto_saved_level():
	var data = JSON.parse_string(
		JavaScriptBridge.eval("""localStorage.getItem("%s");""" % SAVE_KEY)
	)

	if data == null:
		return

	var level_name = data.get("current_level", "intro_level")
	get_tree().change_scene_to_file(
		"res://levels/%s.tscn" % level_name
	)


func _on_continue_button_pressed():
	if not has_save:
		return

	print("⏩ Save gevonden, laden...")
	goto_saved_level()
