extends Node

signal quiz_finished(success: bool)

@onready var quiz_ui_scene = preload("res://logic/scenes/enemy_quiz_ui.tscn")

var quiz_ui_instance: CanvasLayer
var all_questions = []
var question_pool = []
var enemy_ref: Node = null

func _ready():
	load_questions()

func load_questions():
	var file = FileAccess.open("res://logic/scripts/JSON/quiz_questions.json", FileAccess.READ)
	if file:
		var data = JSON.parse_string(file.get_as_text())
		if typeof(data) == TYPE_DICTIONARY and "questions" in data:
			all_questions = data["questions"]
		file.close()

func start_quiz(enemy):
	if all_questions.is_empty():
		push_warning("⚠ Geen quizvragen geladen!")
		return

	enemy_ref = enemy

	question_pool = all_questions.duplicate()
	question_pool.shuffle()

	# UI aanmaken (of hergebruiken)
	if !quiz_ui_instance:
		quiz_ui_instance = quiz_ui_scene.instantiate()
		get_tree().root.add_child(quiz_ui_instance)
		quiz_ui_instance.connect("answer_selected", Callable(self, "_on_answer_selected"))
	else:
		quiz_ui_instance.show()

	show_next_question()

func show_next_question():
	# Enemy dood → quiz gewonnen
	if enemy_ref == null or enemy_ref.hp <= 0:
		end_quiz(true)
		return

	# Geen vragen meer → opnieuw schudden
	if question_pool.is_empty():
		question_pool = all_questions.duplicate()
		question_pool.shuffle()

	var question = question_pool.pop_front()
	quiz_ui_instance.show()
	quiz_ui_instance.show_question(question)

func _on_answer_selected(index):
	var current_question = quiz_ui_instance.current_question_data

	if index == current_question["answer"]:
		if enemy_ref:
			enemy_ref.take_damage(1)

	# Meteen door → geen pauze
	show_next_question()

func end_quiz(success: bool):
	if quiz_ui_instance:
		quiz_ui_instance.hide()

	if enemy_ref and enemy_ref.player:
		enemy_ref.player.set_process_input(true)
		enemy_ref.player.set_physics_process(true)

	emit_signal("quiz_finished", success)
