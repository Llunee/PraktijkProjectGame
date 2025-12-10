extends StaticBody2D

@export var item: InvItem
var player = null

func _on_area_2d_body_entered(body):
	if body.has_method("Player"):
		player = body
		playercollect()
		await get_tree().create_timer(0.1).timeout
		queue_free()

func playercollect():
	player.collect(item)

@onready var giraffe = get_node("/root/Main/Giraffe")

func _on_body_entered(body):
	if body.name == "Player":
		giraffe.crystals_collected += 1
		queue_free()

		if giraffe.crystals_collected >= giraffe.crystals_needed:
			giraffe.quest_state = giraffe.QuestState.TALK_PART2
