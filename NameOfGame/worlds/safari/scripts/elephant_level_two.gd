extends Area2D

@onready var interact_icon: Node2D = $InteractIcon
@export var player: CharacterBody2D

var is_player_in_range: bool = false
var is_chatting: bool = false


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	Dialogic.signal_event.connect(_on_dialogic_signal)


func _input(event: InputEvent) -> void:
	if is_player_in_range \
	and not is_chatting \
	and event.is_action_pressed("interact") \
	and not is_quest_completed():
		run_dialog("elephant_stuck_in_cactus")

func _on_body_entered(body) -> void:
	if body.name == "Player":
		is_player_in_range = true
		if not is_quest_completed():
			interact_icon.visible = true

func _on_body_exited(body) -> void:
	if body.name == "Player":
		is_player_in_range = false
		interact_icon.visible = false

func run_dialog(dialog_name: String) -> void:
	is_chatting = true
	interact_icon.visible = false
	Dialogic.start(dialog_name)

func _on_dialogic_signal(signal_name: String) -> void:
	print("Signal received:", signal_name, "Player is", player)
	if player:
		if signal_name == "freeze_player":
			player.set_physics_process(false)  
		elif signal_name == "unfreeze_player":
			player.set_physics_process(true)
			is_chatting = false
		elif  signal_name == "generate_spell":
			_generate_spell()


func _generate_spell() -> void:
	var spell_count := 0

	if Dialogic.VAR.has("spell_count"):
		spell_count = Dialogic.VAR.get("spell_count")

	var difficulty = clamp(spell_count + 1, 1, 3)

	var q = Question_creator.generate_question(difficulty)

	Dialogic.VAR.set("spell_question", q.question)
	Dialogic.VAR.set("spell_answer", str(q.answer))


func is_quest_completed() -> bool:
	var completed = Dialogic.VAR.get("quest_elephant_cactus") == "completed"
	if completed:
		z_index = 0
	return completed
