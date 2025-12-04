extends Node

signal player_damaged
signal player_reset
signal coins_updated

var max_health: int = 3
var health: int = max_health
var speed: float = 300.0
var jump_velocity: float = -450.0
var coin_amount : int = 0

func reset():
	health = max_health
	emit_signal("player_reset")

func take_damage(amount: int):
	health = max(health - amount, 0)
	emit_signal("player_damaged")

func heal(amount: int):
	health = min(health + amount, max_health)

func is_dead() -> bool:
	return health <= 0
	
func add_coins(amount: int):
	coin_amount += amount
	emit_signal("coins_updated")
