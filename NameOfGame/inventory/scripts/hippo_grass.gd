extends StaticBody2D

@export var item: InvItem
var player = null

func _process(_delta):
	if player and Input.is_action_just_pressed("pick"):
		playercollect()
		QuestManager.collect_hippo_grass()
		await get_tree().create_timer(0.1).timeout
		queue_free()

func _on_area_2d_body_entered(body):
	if body.has_method("Player"):
		player = body

func playercollect():
	player.collect(item)
