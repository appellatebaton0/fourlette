extends Node
class_name Component

# Mirrors the class_name, just there because classes are stupid.
func get_id() -> String:
	return "Component"

## Obscures the Component class to Variant, so you can recast it to a class variable.
# ie, var me:Area2D = get_me() works, where var me:Area2D = self wouldn't.
func get_me():
	return self

# The actor this component is parented to
@onready var actor:Actor = get_actor()
# Get the actor. Returns the parent if is actor, or possibly a parent component's actor.
func get_actor() -> Actor:
	var parent = get_parent()
	if parent is Actor:
		return parent
	elif parent is Component:
		return parent.get_actor()
	return null

func get_sibling_component(type:String) -> Component:
	for component in actor.components:
		if component.get_id() == type:
			return component
	return null
