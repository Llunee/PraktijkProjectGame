extends Node

const QUEST_START_SIGNAL = "firstQuest"

var bao_buns_collected = 0
var firstQuest = false
const TARGET_AMOUNT = 5

@onready var player_inv: Inv = preload("res://inventory/playerInventory.tres")
@onready var bao_bun_item: InvItem = preload("res://inventory/items/baobuns.tres")
@onready var house_sprite: Sprite2D = get_tree().current_scene.get_node("NewHouse")

func _ready():
	await get_tree().process_frame
	if Dialogic.VAR:
		Dialogic.VAR.set_variable("bao_buns_collected", bao_buns_collected)
		Dialogic.VAR.set_variable("firstQuest", firstQuest)
	else:
		push_error("Dialogic.VAR is nog niet geïnitialiseerd!")
	
	Dialogic.signal_event.connect(Callable(self, "_on_dialogic_quest_start"))

func _on_dialogic_quest_start(signal_name: String):
	if signal_name == QUEST_START_SIGNAL:
		firstQuest = true

		var existing = 0
		for slot in player_inv.slots:
			if slot.item == bao_bun_item:
				existing += slot.amount

		bao_buns_collected = existing
		Dialogic.VAR.set_variable("bao_buns_collected", bao_buns_collected)
		Dialogic.VAR.set_variable("firstQuest", firstQuest)

		print("Bao Bun Quest gestart! Speler had al %d bao buns." % existing)

		if bao_buns_collected >= TARGET_AMOUNT:
			Dialogic.VAR.set_variable("quest_objective_met", true)
			
		else:
			Dialogic.VAR.set_variable("quest_objective_met", false)

func collect_bao_bun():
	if firstQuest and bao_buns_collected < TARGET_AMOUNT:
		bao_buns_collected += 1
		Dialogic.VAR.set_variable("bao_buns_collected", bao_buns_collected)
		print("Bao buns verzameld: " + str(bao_buns_collected))
		
		if bao_buns_collected == TARGET_AMOUNT:
			print("Quest doel voltooid! Ga terug naar de NPC.")
			Dialogic.VAR.set_variable("quest_objective_met", true)
			house_sprite.visible = true
