extends Node2D

@export var target_scene_path: String
@onready var animated_sprite = $AnimatedSprite2D
@onready var interact_label = $PressELabel

var player_inside := false

func _ready() -> void:
	animated_sprite.play("default")

func _on_area_entered(body):
	if body.name == "Player":
		player_inside = true
		interact_label.visible = true

func _on_area_exited(body):
	if body.name == "Player":
		player_inside = false
		if PlayerData.safari_world_finished:
			interact_label.visible = true

func _process(delta: float) -> void:
	if not PlayerData.safari_world_finished:
		return
	if player_inside and Input.is_action_just_pressed("interact"):
		get_tree().change_scene_to_file(target_scene_path)
