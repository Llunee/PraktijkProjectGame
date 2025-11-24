extends Node

signal player_damaged

var max_health: int = 3
var health: int = max_health
var speed: float = 300.0
var jump_velocity: float = -700.0

func reset():
	health = max_health

func take_damage(amount: int):
	health = max(health - amount, 0)
	emit_signal("player_damaged")

func heal(amount: int):
	health = min(health + amount, max_health)

func is_dead() -> bool:
	return health <= 0
