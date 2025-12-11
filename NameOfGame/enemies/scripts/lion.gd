extends CharacterBody2D

signal hit_player

@export var player: CharacterBody2D
@export var HEALTH: int = 5

@onready var lion_area: Area2D = $AreaLion
@onready var sum_area: Area2D = $sum2D 
@onready var roar_audio: AudioStreamPlayer2D = $AreaLion/AudioStreamPlayer2D

var has_roared = false

func _ready():
	lion_area.body_entered.connect(_on_lion_area_body_entered)
	sum_area.body_entered.connect(_on_sum_area_body_entered)

func _on_lion_area_body_entered(body) -> void:
	if body == player and not has_roared:
			roar_audio.play()
			print("Lion Roar")
			has_roared = true

func _on_sum_area_body_entered(body) -> void:
	if body == player:
		emit_signal("hit_player")

func take_damage(amount: int):
	HEALTH -= amount
	if HEALTH <= 0:
		die()

func die():
	queue_free()
	
