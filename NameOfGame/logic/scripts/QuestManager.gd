extends Node

var quests: Array[Quest] = []
@onready var player_inv: Inv = preload("res://inventory/playerInventory.tres")

func _ready():
	_load_quests()
	await get_tree().process_frame

	if Engine.has_singleton("Dialogic"):
		Dialogic.signal_event.connect(Callable(self, "_on_dialog_event"))
	else:
		push_error("Dialogic singleton niet gevonden!")

func _load_quests():
	var dir = DirAccess.open("res://logic/scripts/quests/")
	if not dir:
		push_error("Kan questmap niet openen: res://logic/scripts/quests/")
		return

	dir.list_dir_begin()
	var file = dir.get_next()
	while file != "":
		if file == "." or file == "..":
			file = dir.get_next()
			continue

		if file.ends_with(".tres"):
			var path = "res://logic/scripts/quests/" + file  
			var q_res = ResourceLoader.load(path)
			if q_res and q_res is Quest:
				quests.append(q_res)
				print("Loaded quest:", q_res.id, "from", path)
			else:
				print("Bestand is geen Quest:", path)
		file = dir.get_next()
	dir.list_dir_end()
	print("Totaal geladen quests:", quests.size())

func _on_dialog_event(event_name: String) -> void:
	print("Dialogic event ontvangen:", event_name)
	for quest in quests:
		if quest.start_signal == event_name:
			start_quest(quest)

func start_quest(quest: Quest) -> void:
	if quest.active: 
		print("Quest al actief:", quest.id)
		return

	quest.active = true
	quest.current_amount = count_item(quest.target_item)
	quest.complete = quest.current_amount >= quest.target_amount
	Dialogic.VAR.set_variable(quest.start_signal, true)
	_update_dialogic(quest)
	print("Quest gestart:", quest.id, "current:", quest.current_amount)


func count_item(item: InvItem) -> int:
	var total := 0
	for slot in player_inv.slots:
		if slot.item == item:
			total += slot.amount
	return total

func collect_item(item: InvItem) -> void:
	print("collect_item aangeroepen met:", item)
	for quest in quests:
		if quest.active and not quest.complete and quest.target_item == item:
			quest.current_amount += 1
			print("Quest", quest.id, "nu:", quest.current_amount, "/", quest.target_amount)
			if quest.current_amount >= quest.target_amount:
				quest.complete = true
				print("Quest voltooid:", quest.id)
			_update_dialogic(quest)

func _update_dialogic(quest: Quest) -> void:
	Dialogic.VAR.set_variable(quest.id + "_current", quest.current_amount)
	Dialogic.VAR.set_variable(quest.id + "_active", quest.active)
	Dialogic.VAR.set_variable(quest.id + "_complete", quest.complete)
