extends Area2D

var is_player_in_range: bool = false
var is_chatting: bool = false
	
func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	
func _input(event: InputEvent) -> void:
	if is_player_in_range and event.is_action_pressed("talk"):
		print("talk")
		run_dialog("firstQuest")

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		is_player_in_range = true
		print("Druk op 'E' om te praten.")

func _on_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		is_player_in_range = false
		print("Speler is buiten bereik.")

func run_dialog(dialog_name):
	is_chatting = false
	Dialogic.start(dialog_name)
