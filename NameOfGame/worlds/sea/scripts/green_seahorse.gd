extends Area2D

@export var purple_seahorse: CharacterBody2D
@export var success_timeline := "seahorse_escort_success"

@onready var interact_icon: Node2D = $InteractIcon
var completed := false

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if completed:
		return

	if body.name != "Player":
		return

	if not Dialogic.VAR.get("escort_active"):
		return

	completed = true

	if purple_seahorse:
		purple_seahorse.stop_following_at_current_position()


	Dialogic.VAR.set_variable("escort_active", false)

	await get_tree().process_frame
	Dialogic.start(success_timeline)
	interact_icon.visible = false
