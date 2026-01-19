extends StaticBody2D


func _ready() -> void:
	falling()

func falling():
	$AnimationPlayer.play("falling")
	await $AnimationPlayer.animation_finished
	$AnimationPlayer.play("fade")
	await $AnimationPlayer.animation_finished
