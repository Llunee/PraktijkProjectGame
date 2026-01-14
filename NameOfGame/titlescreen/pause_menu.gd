extends Control

@onready var consoles_overlay = $ConsolesOverlay
@onready var change_animal_overlay = $ChangeAnimalOverlay
@onready var progress_overlay = $ProgressOverlay

# level progress labels
@onready var safari_level_progress_label = $ProgressOverlay/NinePatchRect/GridContainer/SafariContainer/LevelsContainer/SafariLevelProgressLabel
@onready var sea_level_progress_label = $ProgressOverlay/NinePatchRect/GridContainer/SeaContainer/LevelsContainer/SeaLevelProgressLabel
@onready var ice_level_progress_label = $ProgressOverlay/NinePatchRect/GridContainer/IceContainer/LevelsContainer/IceLevelProgressLabel
@onready var jungle_level_progress_label = $ProgressOverlay/NinePatchRect/GridContainer/JungleContainer/LevelsContainer/JungleLevelProgressLabel

# coin progress labels
@onready var safari_coins_progress_label = $ProgressOverlay/NinePatchRect/GridContainer/SafariContainer/CoinsContainer/SafariCoinsProgressLabel
@onready var sea_coins_progress_label = $ProgressOverlay/NinePatchRect/GridContainer/SeaContainer/CoinsContainer/SeaCoinsProgressLabel
@onready var ice_coins_progress_label = $ProgressOverlay/NinePatchRect/GridContainer/IceContainer/CoinsContainer/IceCoinsProgressLabel
@onready var jungle_coins_progress_label = $ProgressOverlay/NinePatchRect/GridContainer/JungleContainer/CoinsContainer/JungleCoinsProgressLabel

# quest progress labels
@onready var safari_quests_progress_label = $ProgressOverlay/NinePatchRect/GridContainer/SafariContainer/Questscontainer/SafariQuestProgressLabel
@onready var sea_quests_progress_label = $ProgressOverlay/NinePatchRect/GridContainer/SeaContainer/Questscontainer/SeaQuestProgressLabel
@onready var ice_quests_progress_label = $ProgressOverlay/NinePatchRect/GridContainer/IceContainer/Questscontainer/IceQuestProgressLabel
@onready var jungle_quests_progress_label = $ProgressOverlay/NinePatchRect/GridContainer/JungleContainer/Questscontainer/JungleQuestProgressLabel

@onready var player = get_tree().get_current_scene().get_node("Player")

var is_open = false

func _ready() -> void:
	close()
	consoles_overlay.visible = false
	LevelData.connect("progress_updated", Callable(self, "on_progress_update"))

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		if PlayerData.is_sum_ui_open:
			return
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
	on_progress_update()

func _on_progress_back_pressed() -> void:
	progress_overlay.visible = false
	
func on_progress_update() -> void:
	update_levels()
	update_coins()
	update_quests()

func update_levels():
	safari_level_progress_label.text = str(LevelData.get_level_progress_percentage(LevelData.Worlds.SAFARI)) + "%"
	sea_level_progress_label.text = str(LevelData.get_level_progress_percentage(LevelData.Worlds.SEA)) + "%"
	ice_level_progress_label.text = str(LevelData.get_level_progress_percentage(LevelData.Worlds.ICE)) + "%"
	jungle_level_progress_label.text = str(LevelData.get_level_progress_percentage(LevelData.Worlds.JUNGLE)) + "%"

func update_coins():
	safari_coins_progress_label.text = str(LevelData.collected_safari_coins) + "/" + str(LevelData.max_safari_coins)
	sea_coins_progress_label.text = str(LevelData.collected_sea_coins) + "/" + str(LevelData.max_sea_coins)
	ice_coins_progress_label.text = str(LevelData.collected_ice_coins) + "/" + str(LevelData.max_ice_coins)
	jungle_coins_progress_label.text = str(LevelData.collected_jungle_coins) + "/" + str(LevelData.max_jungle_coins)
	
func update_quests():
	safari_quests_progress_label.text = str(LevelData.finished_safari_quests) + "/" + str(LevelData.max_safari_quests)
	sea_quests_progress_label.text = str(LevelData.finished_sea_quests) + "/" + str(LevelData.max_sea_quests)
	ice_quests_progress_label.text = str(LevelData.finished_ice_quests) + "/" + str(LevelData.max_ice_quests)
	jungle_quests_progress_label.text = str(LevelData.finished_jungle_quests) + "/" + str(LevelData.max_jungle_quests)


func _on_save_pressed() -> void:
	SaveManager.save_game(player)
