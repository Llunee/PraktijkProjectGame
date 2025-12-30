extends Node

signal player_damaged
signal player_reset
signal coins_updated

@onready var froggy_spriteframes = preload("res://assets/characters/maincharacter/froggy/froggy_spriteframes.tres")
@onready var panda_spriteframes = preload("res://assets/characters/maincharacter/panda_spriteframes.tres")

var animal: Animals
var spriteframes: SpriteFrames
var max_health: int = 3
var health: int = max_health
var speed: float = 300.0
var jump_velocity: float = -450.0
var coin_amount : int
var safari_world_finished : bool = false

enum Animals {
	PANDA,
	FROG
}

func _ready():
	set_animal(Animals.FROG)

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

func set_animal(animal_name: Animals):
	animal = animal_name
	
	# add character names as they are added to the game
	match animal_name:
		Animals.FROG:
			spriteframes = froggy_spriteframes
		Animals.PANDA:
			spriteframes = panda_spriteframes
