extends Control

var is_open = false

func _ready() -> void:
	close()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		if is_open:
			close()
		else:
			open()

func open():
	get_tree().paused = true
	visible = true
	is_open = true

func close():
	get_tree().paused = false
	visible = false
	is_open = false

func _on_close_pressed() -> void:
	close()


func _on_resume_pressed() -> void:
	close()
