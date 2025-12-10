extends Control

@export var snake: CharacterBody2D

@onready var number_one_label: Label = $NinePatchRect/GridContainer/NumberOne/Label
@onready var operator_label: Label = $NinePatchRect/GridContainer/Operator/Label
@onready var number_two_label: Label = $NinePatchRect/GridContainer/NumberTwo/Label
@onready var line_edit: LineEdit = $NinePatchRect/GridContainer/Answer

var is_open : bool = false
var sum_info : Dictionary

func _ready() -> void:
	if snake:
		snake.connect("hit_player", Callable(self, "_on_player_hit"))
	sum_info = Calculator.get_random_sum("EASY") # originally dependent on difficulty setting
	close()


func _process(delta: float) -> void:
	pass


func open():
	get_tree().paused = true
	
	visible = true
	is_open = true
	

func close():
	get_tree().paused = false
	visible = false
	is_open = false


func fill_labels():
	if !sum_info:
		close()
	
	number_one_label.text = str(sum_info["number_one"])
	number_two_label.text = str(sum_info["number_two"])
	operator_label.text = str(sum_info["operator"])
	line_edit.text = ""


func _on_answer_text_submitted(answer: String) -> void:
	if answer.to_int() == sum_info["answer"]:
		close()
		snake.take_damage(1)
	else:
		close()
		PlayerData.take_damage(1)
		
		
func _on_player_hit():
	sum_info = Calculator.get_random_sum("EASY")
	fill_labels()
	open()
