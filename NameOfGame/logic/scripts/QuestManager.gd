extends Node

const TARGET_AMOUNT = 5

var purple_crystal_collected := 0
var hippo_grass_collected := 0

var firstQuest := false
var hippoQuest := false
var is_chatting: bool = false

@onready var player_inv: Inv = preload("res://inventory/playerInventory.tres")
@onready var purple_crystal: InvItem = preload("res://inventory/items/purple_crystals.tres")
@onready var hippo_grass: InvItem = preload("res://inventory/items/hippo_grass.tres")


func _ready():
	await get_tree().process_frame

	if not Dialogic.VAR:
		push_error("Dialogic.VAR is nog niet geïnitialiseerd!")
		return

	sync_dialogic("purple_crystal_collected", purple_crystal_collected)
	sync_dialogic("hippo_grass_collected", hippo_grass_collected)
	sync_dialogic("firstQuest", firstQuest)
	sync_dialogic("hippoQuest", hippoQuest)

	Dialogic.signal_event.connect(_on_dialogic_signal)

# Signals
func _on_dialogic_signal(signal_name: String):
	match signal_name:
		"add_coins":
			PlayerData.add_coins(5)

		"firstQuest":
			start_quest(
				"firstQuest",
				purple_crystal,
				"purple_crystal_collected"
			)

		"hippoQuest":
			start_quest(
				"hippoQuest",
				hippo_grass,
				"hippo_grass_collected"
			)


# Quest logic
func start_quest(
	quest_flag: StringName,
	item: InvItem,
	collected_var: StringName
):
	set(quest_flag, true)

	var collected := count_item(item)
	set(collected_var, collected)

	sync_dialogic(quest_flag, true)
	sync_dialogic(collected_var, collected)
	sync_dialogic("quest_objective_met", collected >= TARGET_AMOUNT)


func update_collection(
	quest_active: bool,
	collected: int,
	collected_var: StringName
) -> int:
	if not quest_active or collected >= TARGET_AMOUNT:
		return collected

	collected += 1
	sync_dialogic(collected_var, collected)

	if collected >= TARGET_AMOUNT:
		print("Quest doel voltooid! Ga terug naar de NPC.")
		sync_dialogic("quest_objective_met", true)

	return collected


# Collecting
func collect_purple_crystal():
	purple_crystal_collected = update_collection(
		firstQuest,
		purple_crystal_collected,
		"purple_crystal_collected"
	)

func collect_hippo_grass():
	hippo_grass_collected = update_collection(
		hippoQuest,
		hippo_grass_collected,
		"hippo_grass_collected"
	)

# Other functions
func count_item(item: InvItem) -> int:
	var total := 0
	for slot in player_inv.slots:
		if slot.item == item:
			total += slot.amount
	return total


func sync_dialogic(var_name: StringName, value):
	Dialogic.VAR.set_variable(var_name, value)
