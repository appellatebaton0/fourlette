extends Node
class_name BehaviorState
func get_me():
	return self

@onready var component:BehaviorComponent = get_component()
func get_component() -> BehaviorComponent:
	return get_parent() if get_parent() is BehaviorComponent else null

func active(_delta:float):
	pass
func inactive(_delta:float):
	pass
func phys_active(_delta:float):
	pass
func phys_inactive(_delta:float):
	pass
func on_active():
	pass
func on_inactive():
	pass
