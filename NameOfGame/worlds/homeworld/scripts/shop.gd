extends Area2D

@onready var player = %Player
@onready var interact_label = $Control/PressELabel

var is_player_in_range: bool = false
	
func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		is_player_in_range = true
		interact_label.text = "De eigenaar is op vakantie"
		interact_label.visible = true

func _on_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		is_player_in_range = false
		interact_label.visible = false
