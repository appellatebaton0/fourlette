extends Component
class_name AttackComponent
func get_id() -> String:
	return "AttackComponent"
var me:Area2D = get_me()

@export var damage:float = 40.0
@export var knockback:float = 30.0

func _on_body_entered(body: Node2D) -> void:
	var target_actor = body
	if target_actor is Component:
		target_actor = target_actor.actor
		
		var health_component:HealthComponent = target_actor.get_component("HealthComponent")
		var behavior_component:BehaviorComponent = target_actor.get_component("BehaviorComponent")
		
		if health_component != null:
			health_component.modify_health(-damage)
		if behavior_component != null:
			behavior_component.take_knockback(actor, knockback)
	pass # Replace with function body.
