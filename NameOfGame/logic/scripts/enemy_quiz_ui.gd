extends CanvasLayer

signal answer_selected(index: int)

@onready var question_label = $VBoxContainer/Label
@onready var buttons = [
	$VBoxContainer/Button,
	$VBoxContainer/Button2,
	$VBoxContainer/Button3,
	$VBoxContainer/Button4
]

var current_question_data
var input_locked := false

func show_question(question_data: Dictionary):
	current_question_data = question_data
	visible = true
	input_locked = false

	question_label.text = question_data["question"]

	for i in range(buttons.size()):
		var button = buttons[i]
		button.text = question_data["options"][i]
		button.disabled = false

		if button.pressed.is_connected(_on_button_pressed):
			button.pressed.disconnect(_on_button_pressed)

		button.pressed.connect(_on_button_pressed.bind(i))

func _on_button_pressed(index: int):
	if input_locked:
		return

	input_locked = true

	for button in buttons:
		button.disabled = true

	emit_signal("answer_selected", index)
