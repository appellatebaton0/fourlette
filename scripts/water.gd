extends Node2D
class_name Water

@export var camera:Camera
const WATER_RISE_AMOUNT:float = 10000.0

@export var layer_texture:Texture2D

func _ready() -> void:
	Global.day_ended.connect(_on_day_ended)
	modulate.a = 1.0

func get_camera_underbound():
	var viewrect:Rect2 = get_viewport_rect()
	return camera.global_position.y + (viewrect.size.y / 2 / camera.zoom.y)

func make_new_water_layer() -> Sprite2D:
	var new = Sprite2D.new()
	new.texture = layer_texture
	
	add_child(new)
	new.global_position.y = Global.water_level + (256 * (1 + new.get_index()))
	
	return new

func _process(delta: float) -> void:
	
	var last_child:Node2D = get_child(get_child_count() - 1)
	
	while last_child.global_position.y < get_camera_underbound():
		make_new_water_layer()
		last_child = get_child(get_child_count() - 1)
	
	for child in get_children():
		if child is Node2D:
			child.global_position.y = Global.water_level + (256 * (1 + child.get_index())) - 128
	
	if abs(last_child.global_position.y - get_camera_underbound()) > 40:
		last_child.queue_free()
	
	modulate.a = move_toward(modulate.a, 0.5 if Global.player_is_in_water else 1.0, delta)
	

func _on_day_ended(depth:int):
	if depth != 1:
		return
	Global.water_level -= WATER_RISE_AMOUNT
