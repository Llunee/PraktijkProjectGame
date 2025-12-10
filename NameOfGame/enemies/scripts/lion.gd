extends CharacterBody2D

@export var player: CharacterBody2D

@onready var lion_area: Area2D = $AreaLion
@onready var roar_audio: AudioStreamPlayer2D = $AreaLion/AudioStreamPlayer2D

var has_roared = false

func _ready():
	lion_area.connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body) -> void:
	print("Iemand is de area binnengekomen") # <-- Nieuwe debug-regel
	if body == player and not has_roared:
		roar_audio.play()
		print("roar")
		has_roared = true
