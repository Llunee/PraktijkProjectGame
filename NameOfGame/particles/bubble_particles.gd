extends CPUParticles2D

var time := 0.0

func _process(delta):
	time += delta
	gravity.x = sin(time * 1.5) * 30
