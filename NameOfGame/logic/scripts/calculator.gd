class_name Calculator

const EASY_OPERATORS = ["+", "-"]
const MEDIUM_OPERATORS = ["+", "-", "*"]
const HARD_OPERATORS = ["+", "-", "*", "/"]

static var rng = RandomNumberGenerator.new()


static func get_random_sum(difficulty: String):
	var operator = _get_appropriate_operator(difficulty)
	var max_number_random = _get_appropriate_number(difficulty)
	var number_one = rng.randi_range(1, max_number_random)
	var number_two = rng.randi_range(1, max_number_random)
	
	if operator == "/" or operator == "*":
		# make sure player never has to multiply/divide by more than 10
		number_two = rng.randi_range(1, 10) 
	
	if operator == "-" or operator == "/":
		if number_one < number_two:
			var temp = number_one
			number_one = number_two
			number_two = temp
	
	var answer = _get_answer(number_one, number_two, operator)
	
	var json_response = {
		"number_one": number_one,
		"number_two": number_two,
		"operator": operator,
		"answer": answer
	}
	
	return json_response


static func _get_appropriate_operator(difficulty: String):
	match difficulty:
		"EASY":
			return EASY_OPERATORS.pick_random()
		"MEDIUM":
			return MEDIUM_OPERATORS.pick_random()
		"HARD":
			return HARD_OPERATORS.pick_random()
		

static func _get_appropriate_number(difficulty: String):
	match difficulty:
		"EASY":
			return 10
		"MEDIUM":
			return 100
		"HARD":
			return 100
		

static func _get_answer(number_one, number_two, operator):
	match operator:
		"+":
			return number_one + number_two
		"-":
			return number_one - number_two
		"*":
			return number_one * number_two
		"/":
			return number_one / number_two
