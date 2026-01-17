extends Node

signal player_damaged
signal player_reset
signal coins_updated
signal spriteframes_updated
signal player_on_ice
signal player_off_ice
signal player_reset_level
signal player_loaded

@onready var froggy_spriteframes = preload("res://assets/characters/maincharacter/froggy/froggy_spriteframes.tres")
@onready var panda_spriteframes = preload("res://assets/characters/maincharacter/panda_spriteframes.tres")
@onready var mouse_spriteframes = preload("res://assets/characters/maincharacter/mouse/mouse_spriteframes.tres")
@onready var bunny_spriteframes = preload("res://assets/characters/maincharacter/bunny/bunny_spriteframes.tres")

var animal: Animals
var spriteframes: SpriteFrames
var max_health: int = 3
var health: int = max_health
var speed: float = 300.0
var jump_velocity: float = -450.0
var coin_amount : int
var safari_world_finished : bool = false
var safari_progress : int = 0
var sea_progress : int = 0
var ice_progress : int = 0
var jungle_progress : int = 0
var difficulty: int = 2
var is_sum_ui_open : bool = false
var loaded_from_save : bool = false

enum Animals {
	PANDA,
	FROG,
	MOUSE,
	BUNNY
}

func _ready():
	set_animal(Animals.FROG)

func reset():
	health = max_health
	emit_signal("player_reset")

func reset_level():
	emit_signal("player_reset_level")

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
		Animals.MOUSE:
			spriteframes = mouse_spriteframes
		Animals.BUNNY:
			spriteframes = bunny_spriteframes
			
	emit_signal("spriteframes_updated")
			
func set_safari_world_finished(happened : bool):
	safari_world_finished = happened

func is_on_ice():
	emit_signal("player_on_ice")
	speed = 400
	
func is_off_ice():
	emit_signal("player_off_ice")
	speed = 300

func sum_ui_open():
	is_sum_ui_open = true

func sum_ui_closed():
	is_sum_ui_open = false

func update_difficulty(time: float, correct: bool):
	difficulty = Difficuly.calculate_difficulty(time, correct, difficulty)
	
# saving things
func to_dict(position: Vector2) -> Dictionary:
	return {
		"difficulty": difficulty,
		"animal": animal,
		"position": {
			"x": position.x,
			"y": position.y
		}
	}

func from_dict(data: Dictionary, player_node: Node2D):
	var saved_world = int(data.get("progress").get("location").get("world"))
	var saved_level =  int(data.get("progress").get("location").get("level"))
	var current_world = LevelData.get_current_world()
	var current_level = LevelData.get_current_level()
	if saved_world != current_world or saved_level != current_level:
		return
	
	var player_data = data.get("player")
	difficulty = player_data.get("difficulty", 2)
	if player_data.has("animal"):
		var animal_to_load : Animals = _get_animal(player_data["animal"])
		set_animal(animal_to_load)

	var pos = player_data.get("position", {})
	player_node.global_position = Vector2(
		pos.get("x", 0),
		pos.get("y", 0)
	)
	loaded_from_save = true
	emit_signal("player_loaded")

func _get_animal(number: float):
	var number_int = int(number)
	match number_int:
		0: return Animals.PANDA
		1: return Animals.FROG
		2: return Animals.MOUSE
		3: return Animals.BUNNY
		
	return Animals.PANDA
