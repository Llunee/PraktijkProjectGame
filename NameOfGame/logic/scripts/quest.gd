extends Resource
class_name Quest

@export var id: String = ""
@export var start_signal: String = ""
@export var target_item: InvItem
@export var target_amount: int = 1

var current_amount: int = 0
var active: bool = false
var complete: bool = false
