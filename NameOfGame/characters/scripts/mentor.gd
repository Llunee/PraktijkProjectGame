extends Area2D

@export var dialog_ui : Control

@onready var player = %Player
@onready var pressELabel = %PressELabel
@onready var dialog_text = null

var player_inside = false
var facing_right = false

func _ready() -> void:
	pressELabel.visible = false
	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("body_exited", Callable(self, "_on_body_exited"))
	dialog_ui.connect("dialog_closed", Callable(self, "_on_dialog_closed"))

func _process(delta: float) -> void:
	if player.global_position.x > global_position.x:
		facing_right = true
	else:
		facing_right = false
		
	if player_inside and Input.is_action_just_pressed("talk"):
		_open_dialog()
	
	$AnimatedSprite2D.play("default")
		
	$AnimatedSprite2D.flip_h = facing_right

func _on_body_entered(body: Node) -> void:
	if body == player:
		player_inside = true
		pressELabel.text = "Druk op E!"
		pressELabel.visible = true

func _on_body_exited(body: Node) -> void:
	if body == player:
		player_inside = false
		pressELabel.text = "Druk op E!"
		pressELabel.visible = false

func _open_dialog() -> void:
	pressELabel.visible = false
	get_tree().paused = true

	dialog_ui.open_dialog()
	
func _close_dialog() -> void:
	get_tree().paused = false
	if player_inside:
		pressELabel.visible = true

func _on_dialog_closed() -> void:
	_close_dialog()
