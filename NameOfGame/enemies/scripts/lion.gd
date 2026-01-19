extends CharacterBody2D

signal hit_player

@export var player: CharacterBody2D
@export var HEALTH: int = 5
@export var enemy_hud_scene: PackedScene
@export var hud_offset: Vector2 = Vector2.ZERO

@onready var lion_area: Area2D = $AreaLion
@onready var sum_area: Area2D = $sum2D 
@onready var roar_audio: AudioStreamPlayer2D = $AreaLion/AudioStreamPlayer2D

var has_roared = false
var enemy_hud: EnemyHUD

func _ready():
	lion_area.body_entered.connect(_on_lion_area_body_entered)
	sum_area.body_entered.connect(_on_sum_area_body_entered)
	
	if enemy_hud_scene:
		enemy_hud = enemy_hud_scene.instantiate()
		get_tree().current_scene.add_child.call_deferred(enemy_hud)
		enemy_hud.setup(HEALTH)
		hud_offset.x = -((HEALTH * 16) / 2.0)
		hud_offset.y = -100

func _process(_delta):
	if enemy_hud:
		enemy_hud.global_position = global_position + hud_offset

func _on_lion_area_body_entered(body) -> void:
	if body == player and not has_roared:
			roar_audio.play()
			has_roared = true

func _on_sum_area_body_entered(body) -> void:
	if body == player:
		emit_signal("hit_player", self)

func take_damage(amount: int):
	HEALTH -= amount
	if enemy_hud:
		enemy_hud.set_health(HEALTH)
	
	if HEALTH <= 0:
		die()
	else:
		emit_signal("hit_player", self)

func die():
	if enemy_hud:
		enemy_hud.queue_free()
	queue_free()
	
