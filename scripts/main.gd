extends Node
class_name Main

@export var player:Actor
@export var water:Water

@onready var player_behavior:BehaviorComponent = player.get_component("BehaviorComponent")

func _ready() -> void:
	Global.spawn_particle.connect(_on_spawn_particle)
	Global.day_ended.connect(_on_day_ended)
	
func _process(delta: float) -> void:
	Global.player_is_in_water = (player.global_position.y > Global.water_level)
	Global.player_will_be_in_water = (player.global_position.y > Global.water_level - water.WATER_RISE_AMOUNT)
	
	if player.global_position.y < -16000:
		$CanvasLayer/UI/End.modulate.a += delta;
	# print(Global.player_is_in_water)

func _on_spawn_particle(particle:Particle, at:Vector2):
	add_child(particle)
	particle.global_position = at

func _on_day_ended(depth:int):
	if depth != 1 or not Global.player_will_be_in_water:
		return
	
	# Everything as it should be
	player.global_position = $World/Spawnpoint.global_position
