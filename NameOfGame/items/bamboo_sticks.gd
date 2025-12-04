extends Node2D

var state = "no bamboo"
var player_in_area = false
var bamboo = preload("res://items/bamboo_collectable.tscn")

@export var item: InvItem
var player = null

func _ready() -> void:
	if state == "no bamboo":
		$growth_timer.start()
	elif state == "bamboo":
		$Sprite2D.visible = true
		
func _process(delta):
	if state == "no bamboo":
		$Sprite2D.visible = false
	if state == "bamboo":
		$Sprite2D.visible = true
		if player_in_area:
			if Input.is_action_pressed("pick"):
				state = "no bamboo"
				drop_bamboo()


func _on_pickable_area_body_entered(body):
	if body.has_method("Player"):
		player_in_area = true
		player = body


func _on_pickable_area_body_exited(body):
	if body.has_method("Player"):
		player_in_area = false


func _on_growth_timer_timeout():
	if state == "no bamboo":
		state = "bamboo"

func drop_bamboo():
	var bamboo_instance = bamboo.instantiate()
	bamboo_instance.global_position = $Marker2D.global_position
	get_parent().add_child(bamboo_instance)
	player.collect(item)
	await get_tree().create_timer(3).timeout
	$growth_timer.start()
