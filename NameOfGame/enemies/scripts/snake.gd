extends SmallEnemyBase
class_name Snake

@onready var wander_timer: Timer = $WanderTimer
@onready var idle_timer: Timer = $IdleTimer
@onready var shape_idle: CollisionShape2D = $IdleCollisionShape2D
@onready var shape_walk: CollisionShape2D = $WalkCollisionShape2D
@onready var hit_shape_idle: CollisionShape2D = $Hitbox/IdleCollisionShape2D
@onready var hit_shape_walk: CollisionShape2D = $Hitbox/WalkCollisionShape2D

func _ready():
	super()
	
	if enemy_hud_scene:
		enemy_hud = enemy_hud_scene.instantiate()
		get_tree().current_scene.add_child.call_deferred(enemy_hud)
		enemy_hud.setup(HEALTH)

func _process(_delta):
	if enemy_hud:
		enemy_hud.global_position = global_position + hud_offset

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

func die():
	super()
	shape_idle.disabled = true
	shape_walk.disabled = true

func reset_enemy():
	super()
	shape_idle.disabled = false
	shape_walk.disabled = false
	change_state(States.IDLE)

func _set_shape_for(mode: String):
	shape_idle.disabled = mode != "idle"
	hit_shape_idle.disabled = mode != "idle"
	shape_walk.disabled = mode != "walk"
	hit_shape_walk.disabled = mode != "walk"

func _on_wander_timer_timeout():
	if current_state != States.CHASE:
		change_state(States.IDLE)

func _on_idle_timer_timeout():
	if current_state != States.CHASE:
		change_state(States.WANDER)
