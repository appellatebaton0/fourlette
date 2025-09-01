extends Component
class_name HealthComponent
func get_id() -> String:
	return "HealthComponent"
var me:Node2D = get_me()

signal took_damage
signal reached_zero

@export var max_health:float = 50.0
@export var health:float = 0.0

func modify_health(amount:float):
	if amount == 0:
		return
	
	health = max(0, health + amount)
	
	took_damage.emit()
	if health <= 0:
		reached_zero.emit()
