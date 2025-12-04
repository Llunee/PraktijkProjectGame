extends Area2D

@export var player: CharacterBody2D

@onready var animated_sprite = $AnimatedSprite2D
@onready var damage_shape = $DamageShape
@onready var damage_timer: Timer = $DamageTimer

var player_inside = false

func _ready() -> void:
	animated_sprite.play("default")
	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("body_exited", Callable(self, "_on_body_exited"))


func _process(delta: float) -> void:
	var current_frame = animated_sprite.frame
	if current_frame in [3, 4, 5]:
		damage_shape.disabled = false
		damage_player()
	else:
		damage_shape.disabled = true
	

func damage_player():
	if damage_timer.time_left > 0:
		return
	
	if player_inside:
		PlayerData.take_damage(1)
		damage_timer.start()


func _on_body_entered(body) -> void:
	if body == player:
		player_inside = true

func _on_body_exited(body) -> void:
	if body == player:
		player_inside = false
