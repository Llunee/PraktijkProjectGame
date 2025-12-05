extends Node2D

@onready var start_button: Button = %start_button
@onready var quit_button: Button = %quit_button
@onready var settings_button: Button = %settings

func _ready() -> void:
	start_button.pressed.connect(_on_start_button_pressed)
	quit_button.pressed.connect(_on_quit_button_pressed)

# https://docs.godotengine.org/en/4.4/tutorials/inputs/inputevent.html
func _unhandled_input(event):
	if event.is_action_pressed("start_game"):
		_on_start_button_pressed()

func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://worlds/introworld/scenes/intro_level.tscn")
	
func _on_quit_button_pressed():
	get_tree().quit()
