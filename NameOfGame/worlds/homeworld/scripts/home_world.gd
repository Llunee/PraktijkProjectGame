extends Node2D

@onready var safari_portal = $SafariPortal
@onready var ice_portal = $IcePortal
@onready var sea_portal = $SeaPortal
@onready var jungle_portal = $JunglePortal
@onready var beaver_sea = $BeaverSea
@onready var beaver_jungle = $BeaverJungle
@onready var beaver_ice = $BeaverIce
@onready var fence_sea = $FenceSea
@onready var fence_jungle = $FenceJungle
@onready var fence_ice = $FenceIce

func _ready() -> void:
	if PlayerData.safari_world_finished:
		beaver_ice.queue_free()
		beaver_sea.queue_free()
		fence_ice.queue_free()
		fence_sea.queue_free()

func _process(delta: float) -> void:
	pass
