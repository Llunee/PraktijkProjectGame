extends Node2D

@export var target_scene_path: String
@onready var animated_sprite = $AnimatedSprite2D
@onready var interact_label = $PressELabel

var player_inside := false

func _ready() -> void:
	animated_sprite.play("default")

func _on_area_entered(body):
	if body.is_in_group("player"):
		player_inside = true
		interact_label.visible = true

func _on_area_exited(body):
	if body.is_in_group("player"):
		player_inside = false
		interact_label.visible = false

func _process(delta: float) -> void:
	if player_inside and Input.is_action_just_pressed("interact"):
		PlayerData.loaded_from_save = false
		get_tree().change_scene_to_file(target_scene_path)
