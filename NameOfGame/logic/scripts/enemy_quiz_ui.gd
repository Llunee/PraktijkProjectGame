extends CanvasLayer

signal answer_selected(index: int)

@onready var question_label = $Panel/VBoxContainer/Label
@onready var buttons = [
	$Panel/VBoxContainer/Button,
	$Panel/VBoxContainer/Button2,
	$Panel/VBoxContainer/Button3,
	$Panel/VBoxContainer/Button4
]

func show_question(question_data: Dictionary):
	visible = true
	question_label.text = question_data["question"]

	for i in range(buttons.size()):
		var button = buttons[i]
		button.text = question_data["options"][i]

		if button.pressed.is_connected(_on_button_pressed):
			button.pressed.disconnect(_on_button_pressed)

		button.pressed.connect(_on_button_pressed.bind(i))

func _on_button_pressed(index: int):
	emit_signal("answer_selected", index)
