class_name Difficuly

func calculate_difficulty(avg_time: float, wrong: int, total: int, current_difficulty: float) -> float:
	# --- Step 1: Compute accuracy (0–1) ---
	var accuracy := 1.0
	if total > 0:
		accuracy = float(total - wrong) / float(total)

	# --- Step 2: Compute speed score (0–1) ---
	# expected time grows with difficulty so higher difficulty doesn't unfairly punish speed
	var expected_time := 5.0 * current_difficulty   # tweakable baseline
	var speed_score: float = clamp(expected_time / (avg_time + 0.01), 0.0, 1.0)

	# --- Step 3: Combined performance score (0–1) ---
	var performance := (accuracy * 0.7) + (speed_score * 0.3)

	# --- Step 4: Logistic mapping → 1 to 5 digits ---
	var k := 6.0   # steepness
	var c := 0.5   # center point
	var max_digits := 4.0  # flattening near 4 digits; increase to 5 if wanted

	var difficulty := 1.0 + max_digits / (1.0 + exp(-k * (performance - c)))

	# --- Optional smoothing to avoid jumps ---
	var smoothed: float = lerp(current_difficulty, difficulty, 0.3)

	return smoothed
