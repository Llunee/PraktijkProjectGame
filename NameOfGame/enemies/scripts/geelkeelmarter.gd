extends CharacterBody2D

@export var player: CharacterBody2D
@export var SPEED: int = 50
@export var CHASE_SPEED: int = 150
@export var ACCELERATION: int = 300
@export var hp: int = 3

@onready var sprite: AnimatedSprite2D = $Sprite2D
@onready var ray_cast_horizontal: RayCast2D = $Sprite2D/RayCast2DHorizontaal
@onready var ray_cast_down: RayCast2D = $Sprite2D/RayCast2DDown
@onready var timer = $Timer
@onready var quiz_manager = get_node("/root/QuizManager")

var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction: Vector2 = Vector2.LEFT 
var right_bounds: Vector2
var left_bounds: Vector2

var quiz_active: bool = false

enum States {
	WANDER,
	CHASE
}
var current_state = States.WANDER

func _ready():
	left_bounds = self.position + Vector2(-250, 0)
	right_bounds = self.position + Vector2(250, 0)
	$Area2D.connect("body_entered", Callable(self, "_on_body_entered"))
	QuizManager.connect("quiz_finished", Callable(self, "_on_quiz_finished"))

func _physics_process(delta: float) -> void:
	if quiz_active:
		return # Stop bewegen tijdens quiz

	handle_gravity(delta)
	change_direction()
	handle_movement(delta)
	look_for_player()

func look_for_player():
	if ray_cast_horizontal.is_colliding():
		var collider = ray_cast_horizontal.get_collider()
		if collider == player:
			chase_player()
		elif current_state == States.CHASE:
			stop_chase()
	elif current_state == States.CHASE:
		stop_chase()

func chase_player() -> void:
	timer.stop()
	current_state = States.CHASE

func stop_chase():
	if timer.time_left <= 0:
		timer.start()

func handle_movement(delta: float) -> void:
	if current_state == States.WANDER:
		velocity = velocity.move_toward(direction * SPEED, ACCELERATION * delta)
	else:
		velocity = velocity.move_toward(direction * CHASE_SPEED, ACCELERATION * delta)
	move_and_slide()

func change_direction() -> void:
	if not ray_cast_down.is_colliding():
		_flip_direction()
		return

	if is_on_wall():
		_flip_direction()
		return

	if current_state == States.WANDER:
		if direction.x == 1 and self.position.x >= right_bounds.x:
			_flip_direction()
		elif direction.x == -1 and self.position.x <= left_bounds.x:
			_flip_direction()
	else:
		direction = (player.position - self.position).normalized()
		direction = sign(direction)
		sprite.scale.x = -1 if direction.x == 1 else 1

func _flip_direction():
	if direction.x == 1:
		direction = Vector2(-1, 0)
		sprite.scale.x = 1
	else:
		direction = Vector2(1, 0)
		sprite.scale.x = -1

func handle_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta

func _on_timer_timeout():
	current_state = States.WANDER

# ------------------------------
# QUIZ LOGICA
# ------------------------------
func _on_body_entered(body):
	if body == player and !quiz_active:
		start_quiz()

func start_quiz():
	quiz_active = true
	current_state = States.WANDER
	velocity = Vector2.ZERO
	player.set_process_input(false)
	player.set_physics_process(false)  
	QuizManager.start_quiz(self)

func take_damage(amount: int):
	hp -= amount
	print("Enemy HP:", hp)
	if hp <= 0:
		queue_free()

func _on_quiz_finished(success: bool):
	quiz_active = false
	player.set_process_input(true)
