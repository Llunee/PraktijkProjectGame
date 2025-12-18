extends CanvasLayer

func _ready():
	visible = false
	get_tree().paused = false
	
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("pause"):
		if get_tree().paused:
			visible = false
			get_tree().paused = false
		else:
			visible = true
			get_tree().paused = true
	

func _on_resume_pressed() -> void:
	visible = false
	get_tree().paused = false


func _on_controles_pressed() -> void:
	pass # Replace with function body.
