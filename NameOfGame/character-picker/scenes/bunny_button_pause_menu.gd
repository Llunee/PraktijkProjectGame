extends Control

@onready var button : Button = $Panda

func _ready() -> void:
	pass 


func _process(delta: float) -> void:
	pass

func _on_button_pressed() -> void:
	PlayerData.set_animal(PlayerData.Animals.BUNNY)
