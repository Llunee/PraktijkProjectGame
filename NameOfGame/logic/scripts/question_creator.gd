class_name Question_creator

static func rand_digits(d: int, operator: String) -> int:
	var min_val = int(pow(10, d - 1))
	var max_val = int(pow(10, d)) - 1
	var value = randi_range(min_val, max_val)
	
	if operator == "+" or operator == "-":
		return value
		
	return int(round(value / 10)) * 10

static func generate_question(difficulty: int) -> Dictionary:
	var rng = RandomNumberGenerator.new()
	
	# set weights per operation
	var current_world : LevelData.Worlds = LevelData.get_current_world()
	# make sure intro questions are super easy
	if current_world == LevelData.Worlds.INTRO:
		difficulty = 1
	
	var weights = PackedFloat32Array([1, 1, 1, 1])
	match current_world:
		LevelData.Worlds.SAFARI:
			weights = PackedFloat32Array([2, 2, 0.25, 0.25])
		LevelData.Worlds.SEA:
			weights = PackedFloat32Array([0.25, 0.25, 2, 0.25])
		LevelData.Worlds.ICE:
			weights = PackedFloat32Array([0.25, 0.25, 0.25, 2])
		LevelData.Worlds.JUNGLE:
			pass # jungle does not exist yet
	
	# Pick operation
	var operations = ["+", "-", "/", "*"]
	var op = operations[rng.rand_weighted(weights)]
	
	var a: int
	var b: int
	var question: String
	var answer: int

	if op == "+":
		a = rand_digits(difficulty, op)
		b = rand_digits(difficulty, op)
		answer = a + b
		question = "%d + %d" % [a, b]

	elif op == "-":
		a = rand_digits(difficulty, op)
		b = rand_digits(difficulty, op)
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
		while true:
			b = int(rand_digits(difficulty, op) / 10)
			if b >= 1:
				break
		a = answer * b               # ensures a / b = answer
		question = "%d / %d" % [a, b]

	# ---------------------------
	# Multiplication (*)
	# Ensures the result has <difficulty> digits
	# ---------------------------
	else:
		b = randi_range(2, 12)

		var min_res = int(pow(10, difficulty - 1))
		var max_res = int(pow(10, difficulty)) - 1

		var min_a = int(ceil(min_res / float(b)))
		var max_a = int(floor(max_res / float(b)))

		a = randi_range(min_a, max_a)
		answer = a * b

		question = "%d * %d" % [a, b]

	return {
		"question": question,
		"answer": answer,
		"operator": op,
		"a": a,
		"b": b
	}
