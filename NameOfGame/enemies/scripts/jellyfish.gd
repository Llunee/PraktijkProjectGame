extends SmallEnemyBase

func _ready():
	super()
	
	if enemy_hud_scene:
		enemy_hud = enemy_hud_scene.instantiate()
		get_tree().current_scene.add_child.call_deferred(enemy_hud)
		enemy_hud.setup(HEALTH)
		hud_offset.y -= 10

func _process(_delta):
	if enemy_hud:
		enemy_hud.global_position = global_position + hud_offset
