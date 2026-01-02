extends Area2D

@onready var animated_sprite = $AnimatedSprite2D
@onready var player = %Player
@onready var interact_label = $PressELabel

var is_player_in_range: bool = false
var is_chatting: bool = false
	
func _ready() -> void:
	animated_sprite.play("idle")
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	Dialogic.signal_event.connect(_on_dialogic_signal)

func _process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if is_player_in_range and event.is_action_pressed("interact") and not is_chatting:
		run_dialog("jungle_beaver_story")

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		is_player_in_range = true
		interact_label.visible = true

func _on_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		is_player_in_range = false
		interact_label.visible = false

func run_dialog(dialog_name):
	is_chatting = true
	Dialogic.start(dialog_name)
	
func _on_dialogic_signal(signal_name: String) -> void:
	if player:
		if signal_name == "freeze_player":
			player.set_physics_process(false)
			if player.global_position.x > global_position.x:
				animated_sprite.flip_h = true  
			animated_sprite.play("talk")
		elif signal_name == "unfreeze_player":
			player.set_physics_process(true)
			is_chatting = false
			animated_sprite.flip_h = false  
			animated_sprite.play("idle")
