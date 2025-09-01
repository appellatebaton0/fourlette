extends Node
class_name Main

@export var player:Actor
@onready var player_behavior:BehaviorComponent = player.get_component("BehaviorComponent")

func _process(delta: float) -> void:
	Global.player_is_in_water = player_behavior.current_state is WaterControlBehaviorState
