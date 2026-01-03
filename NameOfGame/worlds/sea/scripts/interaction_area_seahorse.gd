extends Area2D

@export var seahorse: CharacterBody2D
@onready var interact_icon = $"../InteractIcon"

var is_player_in_range := false
var is_chatting := false

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _input(event):
	if is_player_in_range and event.is_action_pressed("interact") and not is_chatting:
		is_chatting = true
		interact_icon.visible = false
		Dialogic.start("seahorse_find_other_quest")

func _on_body_entered(body):
	if body.name == "Player":
		is_player_in_range = true
		if not Dialogic.VAR.get("quest_find_seahorse") == "completed":
			interact_icon.visible = true

func _on_body_exited(body):
	if body.name == "Player":
		is_player_in_range = false
		interact_icon.visible = false
