extends Area2D

var is_player_in_range: bool = false
var is_chatting: bool = false
var player: Node2D = null
	
func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	Dialogic.signal_event.connect(_on_dialogic_signal)
	
func _input(event: InputEvent) -> void:
	if is_player_in_range and event.is_action_pressed("talk"):
		run_dialog("introduction_story")

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		is_player_in_range = true
		player = body

func _on_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		is_player_in_range = false
		player = null

func run_dialog(dialog_name):
	is_chatting = false
	Dialogic.start(dialog_name)
	
func _on_dialogic_signal(signal_name: String) -> void:
	if player:
		if signal_name == "freeze_player":
			player.set_physics_process(false)  
		elif signal_name == "unfreeze_player":
			player.set_physics_process(true)
			is_chatting = false
