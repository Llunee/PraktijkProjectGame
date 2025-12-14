extends StaticBody2D

@export var item: InvItem
var player = null

func _on_area_2d_body_entered(body):
	if body.has_method("Player"):
		player = body
		playercollect()
		QuestManager.collect_purple_crystal()
		await get_tree().create_timer(0.1).timeout
		queue_free()

func playercollect():
	player.collect(item)
