extends CharacterBody2D

signal player_died
signal player_respawned

var kill_height = 500

@export var inv: Inv

@onready var sprite = $AnimatedSprite2D
@onready var particles = $leaf/CPUParticles2D

var screen_size
var facing_right = false
var can_move = true
var start_location
var health_label

func _ready():
	PlayerData.connect("player_damaged", Callable(self, "handle_damage"))
	screen_size = get_viewport_rect().size
	start_location = global_position

func _physics_process(delta: float) -> void:
	if !can_move:
		return

	if global_position.y > kill_height:
		die()

	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = PlayerData.jump_velocity

	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * PlayerData.speed
		facing_right = direction > 0
	else:
		velocity.x = move_toward(velocity.x, 0, PlayerData.speed)

	update_animation()
	sprite.flip_h = facing_right
	move_and_slide()

func collect(item):
	inv.insert(item)

func handle_damage():
	if PlayerData.is_dead():
		die()

func die():
	emit_signal("player_died")
	global_position = start_location
	PlayerData.reset()
	emit_signal("player_respawned")

func update_animation():
	if not is_on_floor():
		sprite.play("jump")
	elif velocity.x != 0:
		sprite.play("walk")
	else:
		sprite.play("idle")
	
func Player():
	pass
