extends Control

signal character_pressed

@export var animal : PlayerData.Animals
@export var icon : CompressedTexture2D

@onready var button : Button = $Button

func _ready():
	button.icon = icon

func _on_button_pressed() -> void:
	PlayerData.set_animal(animal)
	
	emit_signal("character_pressed")
	
	if get_tree().current_scene.scene_file_path.to_lower().contains("character_picker"):
		get_tree().change_scene_to_file("res://titlescreen/intro_scene.tscn")
		PlayerData.loaded_from_save = false
