extends CharacterBody2D

class_name SmallEnemyBase

signal hit_player

@export var player: CharacterBody2D
@export var SPEED: int = 150
@export var CHASE_SPEED: int = 450
@export var ACCELLERATION: int = 600
@export var HEALTH: int = 2
@export var BOUNDS : Vector2 = Vector2(175, 0)
@export var enemy_hud_scene: PackedScene
@export var hud_offset: Vector2 = Vector2.ZERO

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var player_raycast: RayCast2D = $AnimatedSprite2D/PlayerRaycast
@onready var hole_check_left: RayCast2D = $AnimatedSprite2D/FloorRaycastLeft
@onready var hole_check_right: RayCast2D = $AnimatedSprite2D/FloorRaycastRight
@onready var chase_timer: Timer = $ChaseTimer
@onready var damage_timer: Timer = $DamageTimer
@onready var hitbox: Area2D = $Hitbox
@onready var body_collision: CollisionShape2D = $CollisionShape2D

var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction: Vector2
var right_bounds: Vector2
var left_bounds: Vector2
var player_died: bool = false
var left_target_position = Vector2.ZERO
var right_target_position = Vector2.ZERO
var enemy_hud: EnemyHUD
var max_health: int
var spawn_position: Vector2

enum States {
	WANDER,
	CHASE,
	IDLE
}
var current_state = States.WANDER


func _ready():
	spawn_position = global_position
	max_health = HEALTH
	left_bounds = self.position - BOUNDS
	right_bounds = self.position + BOUNDS
	var raycast_length = player_raycast.target_position
	left_target_position = raycast_length
	right_target_position = raycast_length * -1
	
	hud_offset.x = -((HEALTH * 16) / 2.0)
	hud_offset.y = -40
	
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

func change_state(new_state: States):
	current_state = new_state
	match current_state:
		States.WANDER:
			animated_sprite.play("walk")
			chase_timer.stop()
		States.CHASE:
			animated_sprite.play("walk")
			chase_timer.stop()


func look_for_player():
	var collider = player_raycast.get_collider()
	var colliding_with_player: bool = collider != null and collider == player
	
	if colliding_with_player:
		chase_player()
	elif current_state == States.CHASE and chase_timer.is_stopped():
		stop_chase()


func collide_with_player(body):
	if damage_timer.time_left > 0:
		return
	
	if body == player:
		emit_signal("hit_player", self)
		damage_timer.start()

func handle_movement(delta: float):
	if not hole_check_left.is_colliding() or not hole_check_right.is_colliding():
		change_direction()
	
	if current_state == States.WANDER:
		if is_on_floor() and (not hole_check_left.is_colliding() or not hole_check_right.is_colliding()):
			velocity = Vector2.ZERO
			change_direction()
			velocity = velocity.move_toward(direction * SPEED, ACCELLERATION * delta)
		else:
			velocity = velocity.move_toward(direction * SPEED, ACCELLERATION * delta)
	elif current_state == States.CHASE:
		if direction.x == -1 and not hole_check_left.is_colliding():
			velocity = Vector2.ZERO
		elif direction.x == 1 and not hole_check_right.is_colliding():
			velocity = Vector2.ZERO
		else:
			velocity = velocity.move_toward(direction * CHASE_SPEED, ACCELLERATION * delta)
	else:
		velocity = Vector2(0, 0)


func change_direction():
	if current_state == States.WANDER:
#		facing right
		if animated_sprite.flip_h:
			if not hole_check_right.is_colliding():
				animated_sprite.flip_h = false
				player_raycast.target_position = left_target_position
#			before hitting right bound, move right
			if self.position.x <= right_bounds.x:
				direction = Vector2(1, 0)
#			after hitting right bound, flip sprite to the left and move left
			else:
				animated_sprite.flip_h = false
				player_raycast.target_position = left_target_position
#		facing left
		else:
			if not hole_check_left.is_colliding():
				animated_sprite.flip_h = true
				player_raycast.target_position = right_target_position
#			before hitting left bound, move left
			if self.position.x >= left_bounds.x:
				direction = Vector2(-1, 0)
#			after hitting left bound, flip sprite to the right and move right
			else:
				animated_sprite.flip_h = true
				player_raycast.target_position = right_target_position
	elif current_state == States.CHASE:
		direction = (player.position - self.position).normalized()
		direction = sign(direction)
		if direction.x == 1:
			animated_sprite.flip_h = true
			player_raycast.target_position = right_target_position
		else:
			animated_sprite.flip_h = false
			player_raycast.target_position = left_target_position

func chase_player():
	chase_timer.stop()
	change_state(States.CHASE)

func stop_chase():
	if chase_timer.is_stopped():
		chase_timer.start()

func handle_gravity(delta: float):
	if !is_on_floor():
		velocity.y += gravity * delta

func take_damage(amount: int):
	animated_sprite.modulate = Color(1, 0, 0, 0.25)
	await get_tree().create_timer(0.2).timeout
	animated_sprite.modulate = Color.WHITE
	HEALTH -= amount
	if enemy_hud:
		enemy_hud.set_health(HEALTH)
	if HEALTH <= 0:
		die()

func die():
	visible = false
	set_physics_process(false)
	hitbox.monitoring = false
	hitbox.monitorable = false
	
	if body_collision:
		body_collision.disabled = true
	
	if enemy_hud:
		enemy_hud.queue_free()
		enemy_hud = null

func reset_enemy():
	player_died = false
	global_position = spawn_position
	velocity = Vector2.ZERO

	HEALTH = max_health
	current_state = States.WANDER
	change_state(current_state)

	visible = true
	set_physics_process(true)
	hitbox.monitoring = true
	hitbox.monitorable = true
	
	if body_collision:
		body_collision.disabled = false

	if enemy_hud_scene:
		enemy_hud = enemy_hud_scene.instantiate()
		add_child(enemy_hud)
		enemy_hud.position = hud_offset
		enemy_hud.set_health(HEALTH)

# event functions
func _on_chase_timer_timeout() -> void:
	if current_state == States.CHASE:
		change_state(States.WANDER)

func _on_player_died():
	player_died = true
	stop_chase()
	change_state(States.WANDER)

func _on_player_respawned():
	await get_tree().create_timer(1.0).timeout
	player_died = false
	reset_enemy()
