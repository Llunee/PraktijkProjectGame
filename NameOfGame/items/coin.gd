extends Area2D

signal collected(position: Vector2)

@export var coin_value : int

@onready var animated_sprite = $AnimatedSprite2D

var player

func _ready() -> void:
	animated_sprite.play("default")
	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("body_exited", Callable(self, "_on_body_exited")) 


func _process(delta: float) -> void:
	pass

func _on_body_entered(body: Node) -> void:
	if body == player:
		PlayerData.add_coins(coin_value)
		emit_signal("collected", global_position)
		await get_tree().create_timer(0.1).timeout 
		self.queue_free()
