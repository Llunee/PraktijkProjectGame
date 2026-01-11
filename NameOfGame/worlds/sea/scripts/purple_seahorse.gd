extends CharacterBody2D

@export var speed := 80
@export var player: CharacterBody2D 

@onready var interact_icon: Node2D = $InteractIcon
var following := false
var start_position: Vector2

func _ready():
	start_position = global_position
	Dialogic.signal_event.connect(_on_dialogic_signal)

func _physics_process(delta):
	if following:
		var distance = global_position.distance_to(player.global_position)

		if distance > 20:
			var direction = (player.global_position - global_position).normalized()
			velocity = direction * speed
		else:
			velocity = Vector2.ZERO

		move_and_slide()

func start_following():
	following = true
	interact_icon.visible = false

func stop_following_at_current_position():
	following = false
	velocity = Vector2.ZERO

func _on_dialogic_signal(signal_name):
	if signal_name == "start_escort":
		start_following()
