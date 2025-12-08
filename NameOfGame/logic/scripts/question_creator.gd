class_name Question_creator

func rand_digits(d: int) -> int:
	var min_val = int(pow(10, d - 1))
	var max_val = int(pow(10, d)) - 1
	return randi_range(min_val, max_val)

func generate_question(difficulty: int) -> Dictionary:
	# Pick operation
	var operations = ["+", "-", "/", "*"]
	var op = operations[randi() % operations.size()]

	var a: int
	var b: int
	var question: String
	var answer: int

	if op == "+":
		a = rand_digits(difficulty)
		b = rand_digits(difficulty)
		answer = a + b
		question = "%d + %d" % [a, b]

	elif op == "-":
		a = rand_digits(difficulty)
		b = rand_digits(difficulty)
		if b > a:
			var tmp = a
			a = b
			b = tmp
		answer = a - b
		question = "%d - %d" % [a, b]

	# ---------------------------
	# Division (/)
	# (ensure integer answer)
	# ---------------------------
	elif op == "/":
		answer = randi_range(1, 9)   # keep division kid-friendly
		b = rand_digits(difficulty)
		a = answer * b               # ensures a / b = answer
		question = "%d / %d" % [a, b]

	# ---------------------------
	# Multiplication (*)
	# Ensures the result has <difficulty> digits
	# ---------------------------
	else:
		var min_res = int(pow(10, difficulty - 1))
		var max_res = int(pow(10, difficulty)) - 1
		answer = randi_range(min_res, max_res)

		# Try to find a factorization with manageable numbers
		# Pick a divisor b and compute a = answer / b
		while true:
			b = randi_range(2, 12)  # kid-friendly multiplier
			if answer % b == 0:
				a = answer / b
				break

		question = "%d * %d" % [a, b]

	return {
		"question": question,
		"answer": answer,
		"operator": op,
		"a": a,
		"b": b
	}
