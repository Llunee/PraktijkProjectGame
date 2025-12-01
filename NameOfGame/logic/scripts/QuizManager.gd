extends Node

signal quiz_finished(success: bool)

@onready var quiz_ui_scene = preload("res://logic/scenes/enemy_quiz_ui.tscn")
var quiz_ui_instance: CanvasLayer
var all_questions = []
var selected_questions = []
var current_question = 0
var correct_answers = 0
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
	current_question = 0
	correct_answers = 0

	# Kies max 3 willekeurige vragen (of minder als er minder zijn)
	var question_count = min(3, all_questions.size())
	selected_questions = all_questions.duplicate()
	selected_questions.shuffle()
	selected_questions = selected_questions.slice(0, question_count)

	# UI-instantie aanmaken (één keer)
	if !quiz_ui_instance:
		quiz_ui_instance = quiz_ui_scene.instantiate()
		get_tree().root.add_child(quiz_ui_instance)
		quiz_ui_instance.connect("answer_selected", Callable(self, "_on_answer_selected"))
	else:
		quiz_ui_instance.show()

	show_question()

func show_question():
	if current_question >= selected_questions.size():
		end_quiz()
		return

	var q = selected_questions[current_question]
	quiz_ui_instance.show()
	quiz_ui_instance.show_question(q)

func _on_answer_selected(index):
	var q = selected_questions[current_question]
	if index == q["answer"]:
		correct_answers += 1
		if enemy_ref:
			enemy_ref.take_damage(1)

	current_question += 1
	show_question()

func end_quiz():
	if quiz_ui_instance:
		quiz_ui_instance.hide()  # <-- verberg i.p.v. verwijderen
	emit_signal("quiz_finished", correct_answers >= 2)
