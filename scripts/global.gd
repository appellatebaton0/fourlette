extends Node

# Audio
signal play_sfx(sfx:AudioStream, at:Vector2)

signal spawn_particle(particle:Particle, at:Vector2)

signal day_ended(depth:int)

var water_level:float = 0.0
var player_is_in_water:bool = false
var player_will_be_in_water:bool = false

const TIME_IN_DAY:float = 60.0 # * 60 ## The length of a day, in seconds. 5 mins.
var day_time:float = TIME_IN_DAY

func _ready() -> void:
	day_ended.connect(_on_day_ended)

func _process(delta: float) -> void:
	if day_time <= 0:
		if day_time == 0:
			day_ended.emit(0)
			day_time = -1
	else:
		day_time = move_toward(day_time, 0, delta)

func _on_day_ended(depth:int):
	if depth != 1:
		return
	day_time = TIME_IN_DAY
