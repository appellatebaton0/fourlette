extends Control
class_name UI

@onready var day_fade_overlay:FadeOverlay = $DayFadeOverlay

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.day_ended.connect(_on_day_ended)
	day_fade_overlay.fully_faded.connect(_day_fully_faded)

func _on_day_ended(depth:int):
	if depth != 0:
		return
	
	day_fade_overlay.start()
func _day_fully_faded():
	Global.day_ended.emit(1)
