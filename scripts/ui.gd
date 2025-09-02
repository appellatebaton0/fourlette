extends Control
class_name UI

@onready var day_fade_overlay:FadeOverlay = $DayFadeOverlay
@onready var verdict:Label = $DayFadeOverlay/Verdict

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.day_ended.connect(_on_day_ended)
	day_fade_overlay.fully_faded.connect(_day_fully_faded)

func _process(delta: float) -> void:
	verdict.modulate.a = move_toward(verdict.modulate.a, 1.0 if day_fade_overlay.in_pause else 0.0, delta)


func _on_day_ended(depth:int):
	match depth:
		0:
			day_fade_overlay.start()
		1:
			verdict.text = "You Drowned..." if Global.player_will_be_in_water else "You Survived..."

	
	
func _day_fully_faded():
	Global.day_ended.emit(1)
