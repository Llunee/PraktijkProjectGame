extends Node

signal progress_updated

# change level amounts based on how many levels are in the world (cannot be zero)
var max_safari_levels : int = 2
var max_sea_levels : int = 1
var max_ice_levels : int = 1
var max_jungle_levels : int = 1

# change coin amounts based on how many coins are placed in all levels in the world
var max_safari_coins : int = 6
var max_sea_coins : int = 0
var max_ice_coins : int = 27
var max_jungle_coins : int = 0

# change quest amounts based on how many quests are in all levels in the world
var max_safari_quests : int = 4
var max_sea_quests : int = 1
var max_ice_quests : int = 0
var max_jungle_quests : int = 0

# are updated via signals
var collected_safari_coins : int = 0
var collected_sea_coins : int = 0
var collected_ice_coins : int = 0
var collected_jungle_coins : int = 0
var finished_safari_quests : int = 0
var finished_sea_quests : int = 0
var finished_ice_quests : int = 0
var finished_jungle_quests : int = 0
var finished_safari_levels : int = 0
var finished_sea_levels : int = 0
var finished_ice_levels : int = 0
var finished_jungle_levels : int = 0

enum Worlds {
	SAFARI,
	SEA,
	ICE,
	JUNGLE,
	INTRO
}

func _ready() -> void:
	pass

func update_coins(world : Worlds, amount : int):
	match world:
		Worlds.SAFARI:
			collected_safari_coins += amount
		Worlds.SEA:
			collected_sea_coins += amount
		Worlds.ICE:
			collected_ice_coins += amount
		Worlds.JUNGLE:
			collected_jungle_coins += amount
	
	emit_signal("progress_updated")

func update_quests(world : Worlds):
	match world:
		Worlds.SAFARI:
			finished_safari_quests += 1
		Worlds.SEA:
			finished_sea_quests += 1
		Worlds.ICE:
			finished_ice_quests += 1
		Worlds.JUNGLE:
			finished_jungle_quests += 1
	
	emit_signal("progress_updated")

func update_level_progress(world : Worlds):
	match world:
		Worlds.SAFARI:
			finished_safari_levels += 1
		Worlds.SEA:
			finished_sea_levels += 1
		Worlds.ICE:
			finished_ice_levels += 1
		Worlds.JUNGLE:
			finished_jungle_levels += 1
	
	emit_signal("progress_updated")

func get_current_world() -> Worlds:
	var scene_file_name = get_tree().current_scene.scene_file_path.to_lower()
	var current_world : Worlds = Worlds.JUNGLE
	
	if scene_file_name.contains("safari"):
		current_world = Worlds.SAFARI
	elif scene_file_name.contains("sea"):
		current_world = Worlds.SEA
	elif scene_file_name.contains("ice"):
		current_world = Worlds.ICE
	elif scene_file_name.contains("jungle"):
		current_world = Worlds.JUNGLE
	else:
		current_world = Worlds.INTRO
	
	return current_world

func get_current_level() -> int:
	var scene_file_name = get_tree().current_scene.scene_file_path.to_lower()
	var current_level : int = 1
	
	if scene_file_name.contains("one"):
		current_level = 1
	elif scene_file_name.contains("two"):
		current_level = 2
	elif scene_file_name.contains("three"):
		current_level = 3
	else:
		current_level = 4
	
	return current_level

func get_level_progress_percentage(world : Worlds):
	var safari = finished_safari_levels * 100 / max_safari_levels
	var sea = finished_sea_levels * 100 / max_sea_levels
	var ice = finished_ice_levels * 100 / max_ice_levels
	var jungle = finished_jungle_levels * 100 / max_jungle_levels
	
	match world:
		Worlds.SAFARI:
			return safari
		Worlds.SEA:
			return sea
		Worlds.ICE:
			return ice
		Worlds.JUNGLE:
			return jungle

func get_location_dict() -> Dictionary:
	return {
		"world": get_current_world(),
		"level": get_current_level()
	}

func to_dict() -> Dictionary:
	return {
		"coins": {
			"safari": collected_safari_coins,
			"sea": collected_sea_coins,
			"ice": collected_ice_coins,
			"jungle": collected_jungle_coins
		},
		"levels": {
			"safari": finished_safari_levels,
			"sea": finished_sea_levels,
			"ice": finished_ice_levels,
			"jungle": finished_jungle_levels
		},
		"quests": {
			"safari": finished_safari_quests,
			"sea": finished_sea_quests,
			"ice": finished_ice_quests,
			"jungle": finished_jungle_quests
		},
		"location": {
			"world": get_current_world(),
			"level": get_current_level()
		}
	}

func from_dict(data: Dictionary):
	var coins = data.get("coins", {})
	collected_safari_coins = coins.get("safari", 0)
	collected_sea_coins = coins.get("sea", 0)
	collected_ice_coins = coins.get("ice", 0)
	collected_jungle_coins = coins.get("jungle", 0)

	var levels = data.get("levels", {})
	finished_safari_levels = levels.get("safari", 0)
	finished_sea_levels = levels.get("sea", 0)
	finished_ice_levels = levels.get("ice", 0)
	finished_jungle_levels = levels.get("jungle", 0)

	var quests = data.get("quests", {})
	finished_safari_quests = quests.get("safari", 0)
	finished_sea_quests = quests.get("sea", 0)
	finished_ice_quests = quests.get("ice", 0)
	finished_jungle_quests = quests.get("jungle", 0)

	emit_signal("progress_updated")
