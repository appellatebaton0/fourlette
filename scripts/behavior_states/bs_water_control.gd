extends BehaviorState
class_name WaterControlBehaviorState
@onready var me:CharacterBody2D = component.get_me()

@export var exited_water_state:BehaviorState

@export var INPUT_LEFT:String = "Left"
@export var INPUT_RIGHT:String = "Right"
@export var INPUT_DOWN:String = "Down"
@export var INPUT_UP:String = "Up"

@export var MAX_SPEED:float = 1000.0
@export var ACCELERATION:float = 90.0
@export var RESISTANCE:float = 20.0

@export var WATER_GRAVITY:float = 75.0

func phys_active(delta:float):
	var direction:Vector2 = Input.get_vector(INPUT_LEFT, INPUT_RIGHT, INPUT_UP, INPUT_DOWN)
	
	if direction:
		me.velocity.x = move_toward(me.velocity.x, (direction.x * MAX_SPEED), ACCELERATION * (delta * 60))
		me.velocity.y = move_toward(me.velocity.y, (direction.y * MAX_SPEED), ACCELERATION * (delta * 60))
	else:
		me.velocity.x = move_toward(me.velocity.x, 0, RESISTANCE * (delta * 60))
		me.velocity.y = move_toward(me.velocity.y, WATER_GRAVITY, RESISTANCE * (delta * 60))

func active(_delta:float):
	if component.actor.global_position.y + 128 < Global.water_level and exited_water_state != null:
		component.change_state(exited_water_state, me.velocity)
