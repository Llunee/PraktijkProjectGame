extends Control

@onready var color_rect = $ColorRect
@onready var texture_rect = $TextureRect

func _ready() -> void:
	color_rect.visible = true
	texture_rect.visible = false
	texture_rect.modulate.a = 0.0
	Dialogic.signal_event.connect(_on_dialogic_signal)
	run_dialog("mentor_storyline_start")

func run_dialog(dialog_name):
	Dialogic.start(dialog_name)

func _on_dialogic_signal(signal_name: String) -> void:
	if signal_name == "wake":
		color_rect.visible = false
		texture_rect.visible = true
		var tween = create_tween()
		tween.tween_property(texture_rect, "modulate:a", 1.0, 2.0)
	elif signal_name == "end":
		PlayerData.loaded_from_save = false
		get_tree().change_scene_to_file("res://worlds/introworld/scenes/intro_level.tscn")
