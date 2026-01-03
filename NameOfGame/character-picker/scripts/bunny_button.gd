extends Control

func _ready() -> void:
	pass 


func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	PlayerData.set_animal(PlayerData.Animals.BUNNY)
	get_tree().change_scene_to_file("res://worlds/introworld/scenes/intro_level.tscn")
