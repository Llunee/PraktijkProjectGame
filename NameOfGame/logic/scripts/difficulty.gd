class_name Difficuly

static func calculate_difficulty(avg_time: float, got_it_right: bool, current_difficulty: float) -> float:
	# ---------------------------
	# Speed score (0–1)
	# ---------------------------
	var expected_time: float = 5.0 * current_difficulty
	var speed_score: float = clamp(expected_time / (avg_time + 0.01), 0.0, 1.0)

	# ---------------------------
	# Performance signal (-1 to +1)
	# ---------------------------
	var correctness: float = 1.0 if got_it_right else -1.0
	var performance: float = correctness * speed_score

	# ---------------------------
	# Logistic growth curve
	# ---------------------------
	var k: float = 5.0        # steepness
	var c: float = 0.0        # center
	var max_digits: float = 4.0

	var target_difficulty: float = 1.0 + max_digits / (1.0 + exp(-k * (performance - c)))

	# ---------------------------
	# Gentle adjustment (EMA)
	# ---------------------------
	var adjustment_strength: float = 0.15
	var new_difficulty: float = lerp(
		current_difficulty,
		target_difficulty,
		adjustment_strength
	)

	# ---------------------------
	# Clamp final result
	# ---------------------------
	return clamp(new_difficulty, 1.0, 1.0 + max_digits)
