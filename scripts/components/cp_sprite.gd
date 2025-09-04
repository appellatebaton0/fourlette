# Component Setup
extends Component
class_name SpriteComponent
func get_id() -> String:
	return "SpriteComponent"
var me:AnimatedSprite2D = get_me()

@export var behavior_component:BehaviorComponent

func _process(delta: float) -> void:
	if behavior_component.me.velocity.x != 0 and abs(behavior_component.me.velocity.x) > 10:
		me.flip_h = behavior_component.me.velocity.x < 0
