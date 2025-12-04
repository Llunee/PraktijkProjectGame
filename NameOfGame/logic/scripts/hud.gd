extends Control

@export var full_heart_texture: Texture2D
@export var empty_heart_texture: Texture2D

@onready var hearts_parent = $HBoxContainer
@onready var coin_label = $CoinLabel

var hearts_list : Array[TextureRect]

func _ready() -> void:
	PlayerData.connect("player_damaged", Callable(self, "handle_damage"))
	PlayerData.connect("player_reset", Callable(self, "reset_health"))
	PlayerData.connect("coins_updated", Callable(self, "update_coins"))
	for child in hearts_parent.get_children():
		hearts_list.append(child)

func update_hearts_display():
	var health = PlayerData.health
	for i in range(hearts_list.size()):
		if i < health:
			hearts_list[i].texture = full_heart_texture
		else:
			hearts_list[i].texture = empty_heart_texture

func handle_damage():
	update_hearts_display()
	
func reset_health():
	update_hearts_display()
	
func update_coins():
	coin_label.text = str(PlayerData.coin_amount)
