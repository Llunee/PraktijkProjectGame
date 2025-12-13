extends Node2D

@export var float_speed := 2.0
@export var float_height := 4.0

var base_y := 0.0

func _ready():
	base_y = position.y

func _process(delta):
	position.y = base_y + sin(Time.get_ticks_msec() / 200.0) * float_height
