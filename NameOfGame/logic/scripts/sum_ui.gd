extends Control

@export var enemies : Array[CharacterBody2D]

@onready var number_one_label: Label = $NinePatchRect/GridContainer/NumberOne/Label
@onready var operator_label: Label = $NinePatchRect/GridContainer/Operator/Label
@onready var number_two_label: Label = $NinePatchRect/GridContainer/NumberTwo/Label
@onready var line_edit: LineEdit = $NinePatchRect/GridContainer/Answer
@onready var player_timer: Timer = $Player_timer

var is_open : bool = false
var sum_info : Dictionary
var enemy : CharacterBody2D
var time_spent: float = 0

func _ready() -> void:
	if enemies:
		for e in enemies:
			e.connect("hit_player", Callable(self, "_on_player_hit"))
		create_sum_info()
	close()

func open():
	get_tree().paused = true
	
	visible = true
	is_open = true
	await get_tree().process_frame
	line_edit.grab_focus()

func close():
	get_tree().paused = false
	visible = false
	is_open = false

func create_sum_info():
	# difficulty increases with every level
	var current_level : int = LevelData.get_current_level()
	sum_info = Question_creator.generate_question(current_level + 1)

func fill_labels():
	if !sum_info:
		close()
	
	number_one_label.text = str(sum_info["a"])
	number_two_label.text = str(sum_info["b"])
	
	var displayed_operator : String = ""
	
	match str(sum_info["operator"]):
		"*":
			displayed_operator = "×"
		"/":
			displayed_operator = ":"
		"-": 
			displayed_operator = "-"
		"+":
			displayed_operator = "+"
	
	operator_label.text = displayed_operator
	line_edit.text = ""

func _on_answer_text_submitted(answer: String) -> void:
	if answer.to_int() == sum_info["answer"]:
		close()
		enemy.take_damage(1)
		PlayerData.update_difficulty(time_spent, true)
	else:
		close()
		PlayerData.take_damage(1)
		PlayerData.update_difficulty(time_spent, false)
	player_timer.stop()
	time_spent = 0
		
func _on_player_hit(enemy_hit : CharacterBody2D):
	print(enemy_hit)
	player_timer.start()
	enemy = enemy_hit
	sum_info = Question_creator.generate_question(PlayerData.difficulty)
	fill_labels()
	open()


func _on_player_timer_timeout() -> void:
	time_spent += player_timer.wait_time
