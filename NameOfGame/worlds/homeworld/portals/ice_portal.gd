extends Node2D

@onready var animated_sprite = $AnimatedSprite2D

func _ready() -> void:
	animated_sprite.play("default")


func _process(delta: float) -> void:
	pass
