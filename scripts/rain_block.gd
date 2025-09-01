extends Node2D
class_name RainBlock

@export var radius:float = 100.0
@export var smoothing:float = 200.0

func get_opacity(point:Vector2) -> float:
	
	var dist = point.distance_to(global_position)
	return max(min((dist - radius) / smoothing, 1), 0)
