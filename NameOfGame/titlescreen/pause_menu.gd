extends Control

@onready var consoles_overlay = $ConsolesOverlay
@onready var change_animal_overlay = $ChangeAnimalOverlay
@onready var progress_overlay = $ProgressOverlay
@onready var safari_progress_label = $ProgressOverlay/NinePatchRect/GridContainer/SafariContainer/SafariProgressLabel
@onready var sea_progress_label = $ProgressOverlay/NinePatchRect/GridContainer/SeaContainer/SeaProgressLabel
@onready var ice_progress_label = $ProgressOverlay/NinePatchRect/GridContainer/IceContainer/IceProgressLabel
@onready var jungle_progress_label = $ProgressOverlay/NinePatchRect/GridContainer/JungleContainer/JungleProgressLabel

var is_open = false

func _ready() -> void:
	close()
	consoles_overlay.visible = false
	PlayerData.connect("progress_updated", Callable(self, "on_progress_update"))

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		if is_open:
			close()
		else:
			open()

func open():
	get_tree().paused = true
	visible = true
	is_open = true

func close():
	get_tree().paused = false
	visible = false
	is_open = false
	consoles_overlay.visible = false

func _on_close_pressed() -> void:
	close()

func _on_consoles_pressed() -> void:
	consoles_overlay.visible = true

func _on_consoles_back_pressed() -> void:
	consoles_overlay.visible = false

func _on_change_character_pressed() -> void:
	change_animal_overlay.visible = true

func _on_change_animal_back_pressed() -> void:
	change_animal_overlay.visible = false

func _on_progress_pressed() -> void:
	progress_overlay.visible = true

func _on_progress_back_pressed() -> void:
	progress_overlay.visible = false
	
func on_progress_update() -> void:
	safari_progress_label.text = str(PlayerData.safari_progress) + "%"
	sea_progress_label.text = str(PlayerData.sea_progress) + "%"
	ice_progress_label.text = str(PlayerData.ice_progress) + "%"
	jungle_progress_label.text = str(PlayerData.jungle_progress) + "%"
