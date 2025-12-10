extends Area2D

@export var dialog_ui : Control

@onready var player = %Player
@onready var pressELabel = %PressELabel
@onready var dialog_text = null

var player_inside = false
var facing_right = false

enum QuestState {
	TALK_PART1,
	COLLECT_CRYSTALS,
	TALK_PART2,
	DO_SUMS,
	TALK_END
}

var quest_state = QuestState.TALK_PART1
var crystals_collected = 0
var crystals_needed = 5
var crystal_scene = preload("res://inventory/scenes/purple_crystal.tscn")

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

func handle_event(ev):
	match ev:
		"SPAWN_CRYSTALS":
			spawn_crystals()
			quest_state = QuestState.COLLECT_CRYSTALS

		"START_SUMS":
			pass
			#sum_ui.visible = true
			#sum_ui.start_two_sums("5 + 3 = ?", "38 + 45 = ?")
			#quest_state = QuestState.DO_SUMS
			
func spawn_crystals():
	for i in range(crystals_needed):
		var c = crystal_scene.instantiate()
		c.global_position = Vector2(
			randf_range(200, 1200),   # random X gebied
			randf_range(200, 900)     # random Y gebied
		)
		get_tree().current_scene.add_child(c)
