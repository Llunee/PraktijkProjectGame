extends Node

const QUEST_START_SIGNAL = "firstQuest"
const TARGET_AMOUNT = 5

var purple_crystal_collected = 0
var firstQuest = false
var is_chatting: bool = false

@onready var player_inv: Inv = preload("res://inventory/playerInventory.tres")
@onready var purple_crystal: InvItem = preload("res://inventory/items/purple_crystals.tres")

func _ready():
	await get_tree().process_frame
	if Dialogic.VAR:
		Dialogic.VAR.set_variable("purple_crystal_collected", purple_crystal_collected)
		Dialogic.VAR.set_variable("firstQuest", firstQuest)
	else:
		push_error("Dialogic.VAR is nog niet geïnitialiseerd!")

	Dialogic.signal_event.connect(Callable(self, "_on_dialogic_signal"))
	
	
func _on_dialogic_signal(signal_name: String):
	if signal_name == "add_coins":
		PlayerData.add_coins(5)

	if signal_name == QUEST_START_SIGNAL:
		firstQuest = true

		var existing = 0
		for slot in player_inv.slots:
			if slot.item == purple_crystal:
				existing += slot.amount

		purple_crystal_collected= existing
		Dialogic.VAR.set_variable("purple_crystal_collected", purple_crystal_collected)
		Dialogic.VAR.set_variable("firstQuest", firstQuest)

		if purple_crystal_collected >= TARGET_AMOUNT:
			Dialogic.VAR.set_variable("quest_objective_met", true)
			
		else:
			Dialogic.VAR.set_variable("quest_objective_met", false)
			


func collect_purple_crystal():
	if firstQuest and purple_crystal_collected < TARGET_AMOUNT:
		purple_crystal_collected += 1
		Dialogic.VAR.set_variable("purple_crystal_collected", purple_crystal_collected)
		print("Bao buns verzameld: " + str(purple_crystal_collected))
		
		if purple_crystal_collected == TARGET_AMOUNT:
			print("Quest doel voltooid! Ga terug naar de NPC.")
			Dialogic.VAR.set_variable("quest_objective_met", true)
			
