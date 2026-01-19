extends CharacterBody2D

signal player_died
signal player_respawned

var kill_height = 500

@export var inv: Inv
@export var start_location : Vector2

@onready var sprite = $AnimatedSprite2D
@onready var particles = $leaf/CPUParticles2D
@onready var camera = $Camera2D

var screen_size
var facing_right : bool = false
var can_move : bool = true
var respawn_location : Vector2
var is_on_ice = false
var ice_timer := 0.0
var ice_direction := 0.0
var loaded_location : Vector2

func _ready():
	sprite.set("sprite_frames", PlayerData.spriteframes)
	
	PlayerData.update_difficulty()
	PlayerData.connect("player_damaged", Callable(self, "handle_damage"))
	PlayerData.connect("spriteframes_updated", Callable(self, "change_sprite_frames"))
	PlayerData.connect("player_on_ice", Callable(self, "handle_on_ice"))
	PlayerData.connect("player_off_ice", Callable(self, "handle_off_ice"))
	PlayerData.connect("player_reset_level", Callable(self, "reset_level"))
	PlayerData.connect("player_loaded", Callable(self, "_on_player_loaded"))
	
	screen_size = get_viewport_rect().size
	respawn_location = start_location
	handle_off_ice()
	SaveManager.request_load(self)

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

	if direction != 0:
		velocity.x = direction * PlayerData.speed
		facing_right = direction > 0
		ice_direction = direction
		ice_timer = 0.0
	else:
		if is_on_ice and is_on_floor() and ice_timer < 0.5:
			ice_timer += delta
			var t := ice_timer / 0.5
			var slide_speed : float = lerp(PlayerData.speed, 0.0, t)
			velocity.x = ice_direction * slide_speed
		else:
			velocity.x = move_toward(velocity.x, 0, PlayerData.speed)
			ice_direction = 0.0

	update_animation()
	sprite.flip_h = facing_right
	move_and_slide()


func collect(item):
	inv.insert(item)

func handle_damage():
	sprite.modulate = Color(1, 0, 0, 0.25)
	await get_tree().create_timer(0.2).timeout
	sprite.modulate = Color.WHITE
	if PlayerData.is_dead():
		die()

func update_respawn_location(location : Vector2):
	respawn_location = location

func die():
	emit_signal("player_died")
	global_position = respawn_location
	PlayerData.reset()
	emit_signal("player_respawned")

func update_animation():
	if not is_on_floor():
		sprite.play("jump")
	elif velocity.x != 0 and ice_timer <= 0:
		sprite.play("walk")
	else:
		sprite.play("idle")
	
func change_sprite_frames():
	sprite.set("sprite_frames", PlayerData.spriteframes)

func handle_on_ice():
	is_on_ice = true
	
func handle_off_ice():
	is_on_ice = false
	ice_timer = 0.0
	ice_direction = 0.0

func reset_level():
	die() # otherwise player can reset just before dying and avoid respawning enemies

func _on_player_loaded():
	loaded_location = global_position
	
	if PlayerData.loaded_from_save:
		global_position = loaded_location
		if camera:
			camera.reset_smoothing()
			camera.force_update_scroll()
	else:
		global_position = start_location

func Player():
	pass
