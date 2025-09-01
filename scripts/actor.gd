extends Node2D
class_name Actor

@onready var components:Array[Component] = get_components()
func get_components() -> Array[Component]: ## Get all the actor's components
	var return_components:Array[Component]
	
	for child in get_children():
		if child is Component:
			return_components.append(child)
	
	return return_components
func get_component(type:String) -> Component: ## Get a component of a certain id
	for component in components:
		if component.get_id() == type:
			return component
	return null
