extends Area2D

@onready var interact_icon: Node2D = $InteractIcon
@onready var player = %Player
var is_player_in_range: bool = false
var is_chatting: bool = false
	
func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	Dialogic.signal_event.connect(_on_dialogic_signal)
	
func _input(event: InputEvent) -> void:
	if is_player_in_range and event.is_action_pressed("talk"):
		print("talk")
		run_dialog("firstQuest")

func _on_body_entered(body) -> void:
	if body.name == "Player":
		is_player_in_range = true
		interact_icon.visible = true
		print("Druk op 'E' om te praten.")

func _on_body_exited(body) -> void:
	if body.name == "Player":
		is_player_in_range = false
		interact_icon.visible = false
		print("Speler is buiten bereik.")

func run_dialog(dialog_name):
	is_chatting = false
	interact_icon.visible = false
	Dialogic.start(dialog_name)
	
func _on_dialogic_signal(signal_name: String) -> void:
	if player:
		if signal_name == "freeze_player":
			player.set_physics_process(false)  
		elif signal_name == "unfreeze_player":
			player.set_physics_process(true)
			is_chatting = false
