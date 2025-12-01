extends CharacterBody2D

signal hit_player

@export var player: CharacterBody2D
@export var SPEED: int = 75
@export var CHASE_SPEED: int = 150
@export var ACCELLERATION: int = 400
@export var HEALTH: int = 2

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var ray_cast: RayCast2D = $AnimatedSprite2D/RayCast2D
@onready var hole_check_left: RayCast2D = $AnimatedSprite2D/HoleCheckLeft
@onready var hole_check_right: RayCast2D = $AnimatedSprite2D/HoleCheckRight
@onready var chase_timer: Timer = $ChaseTimer
@onready var wander_timer: Timer = $WanderTimer
@onready var damage_timer: Timer = $DamageTimer
@onready var idle_timer: Timer = $IdleTimer
@onready var shape_idle: CollisionShape2D = $IdleCollisionShape2D
@onready var shape_walk: CollisionShape2D = $WalkCollisionShape2D

var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction: Vector2
var right_bounds: Vector2
var left_bounds: Vector2
var player_died: bool = false

enum States {
	WANDER,
	CHASE,
	IDLE
}
var current_state = States.WANDER


func _ready():
	left_bounds = self.position + Vector2(-75, 0)
	right_bounds = self.position + Vector2(75, 0)
	
	change_state(current_state)
	
	if player:
		player.connect("player_died", Callable(self, "_on_player_died"))
		player.connect("player_respawned", Callable(self, "_on_player_respawned"))
		


func _physics_process(delta: float) -> void:
	handle_gravity(delta)
	handle_movement(delta)
	change_direction()
	
	if !player_died:
		look_for_player()
		move_and_slide()
		collide_with_player(get_last_slide_collision())


func change_state(new_state: States):
	current_state = new_state
	match current_state:
		States.IDLE:
			animated_sprite.play("idle")
			_set_shape_for("idle")
			wander_timer.stop()
			chase_timer.stop()
			idle_timer.stop()
			idle_timer.start()
		States.WANDER:
			animated_sprite.play("walk")
			_set_shape_for("walk")
			idle_timer.stop()
			chase_timer.stop()
			wander_timer.stop()
			wander_timer.start()
		States.CHASE:
			animated_sprite.play("walk")
			_set_shape_for("walk")
			idle_timer.stop()
			wander_timer.stop()
			chase_timer.stop()


func _set_shape_for(anim: String):
	shape_idle.disabled = anim != "idle"
	shape_walk.disabled = anim != "walk"


func look_for_player():
	var collider = ray_cast.get_collider()
	var colliding_with_player: bool = collider != null and collider == player
	
	if colliding_with_player:
		chase_player()
	elif current_state == States.CHASE and chase_timer.is_stopped():
		stop_chase()


func collide_with_player(collision_info):
	if !collision_info:
		return
		
	if damage_timer.time_left > 0:
		return
	
	if collision_info.get_collider() == player:
		emit_signal("hit_player")
		damage_timer.start()


func chase_player():
	chase_timer.stop()
	change_state(States.CHASE)


func stop_chase():
	if chase_timer.is_stopped():
		chase_timer.start()


func handle_movement(delta: float):
	if not hole_check_left.is_colliding() or not hole_check_right.is_colliding():
		change_direction()
	
	if current_state == States.WANDER:
		velocity = velocity.move_toward(direction * SPEED, ACCELLERATION * delta)
	elif current_state == States.CHASE:
		if not hole_check_left.is_colliding() or not hole_check_right.is_colliding():
			velocity = Vector2(0, 0)
		else:
			velocity = velocity.move_toward(direction * CHASE_SPEED, ACCELLERATION * delta)
	else:
		velocity = Vector2(0, 0)


func change_direction():
	var left_target_position = Vector2(-75, 0)
	var right_target_position = Vector2(75, 0)
	
	if current_state == States.WANDER:
#		facing right
		if animated_sprite.flip_h:
#			before hitting right bound, move right
			if self.position.x <= right_bounds.x:
				direction = Vector2(1, 0)
#			after hitting right bound, flip sprite to the left and move left
			else:
				animated_sprite.flip_h = false
				ray_cast.target_position = left_target_position
#		facing left
		else:
#			before hitting left bound, move left
			if self.position.x >= left_bounds.x:
				direction = Vector2(-1, 0)
#			after hitting left bound, flip sprite to the right and move right
			else:
				animated_sprite.flip_h = true
				ray_cast.target_position = right_target_position
	elif current_state == States.CHASE:
		direction = (player.position - self.position).normalized()
		direction = sign(direction)
		if direction.x == 1:
			animated_sprite.flip_h = true
			ray_cast.target_position = right_target_position
		else:
			animated_sprite.flip_h = false
			ray_cast.target_position = left_target_position


func handle_gravity(delta: float):
	if !is_on_floor():
		velocity.y += gravity * delta

func take_damage(amount: int):
	HEALTH -= amount
	if HEALTH <= 0:
		die()

func die():
	queue_free()

func _on_chase_timer_timeout() -> void:
	if current_state == States.CHASE:
		change_state(States.WANDER)


func _on_wander_timer_timeout() -> void:
	if current_state != States.CHASE:
		change_state(States.IDLE)
	


func _on_idle_timer_timeout() -> void:
	if current_state != States.CHASE:
		change_state(States.WANDER)


func _on_player_died():
	player_died = true
	stop_chase()
	change_state(States.WANDER)


func _on_player_respawned():
	await get_tree().create_timer(1.0).timeout
	player_died = false
