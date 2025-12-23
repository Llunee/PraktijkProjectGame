extends CharacterBody2D

signal player_died
signal player_respawned

var kill_height = 500

@export var inv: Inv
@export var tilemap: TileMapLayer

@onready var sprite = $AnimatedSprite2D
@onready var particles = $leaf/CPUParticles2D

var screen_size
var facing_right : bool = false
var can_move : bool = true
var respawn_location : Vector2

func _ready():
	sprite.set("sprite_frames", PlayerData.spriteframes)
	PlayerData.connect("player_damaged", Callable(self, "handle_damage"))
	screen_size = get_viewport_rect().size
	respawn_location = global_position
	print("Tilemap:", tilemap)


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
	check_danger_tile()

func collect(item):
	inv.insert(item)

func handle_damage():
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
	elif velocity.x != 0:
		sprite.play("walk")
	else:
		sprite.play("idle")
		
func check_danger_tile():
	if not is_on_floor():
		return

	var foot = global_position + Vector2(0, 32)

	for layer in tilemap.get_parent().get_children():
		if layer is TileMapLayer:
			var cell = layer.local_to_map(layer.to_local(foot))
			var data = layer.get_cell_tile_data(cell)

			if data and data.get_custom_data("danger"):
				print("💀 danger in layer:", layer.name)
				die()
	
func Player():
	pass
