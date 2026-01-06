extends Node2D


func _ready() -> void:
	PlayerData.update_progress(PlayerData.Worlds.SAFARI, 50)


func _process(delta: float) -> void:
	pass
