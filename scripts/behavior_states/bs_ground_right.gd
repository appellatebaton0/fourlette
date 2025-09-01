extends BehaviorState
class_name GroundRightBehaviorState
@onready var me:CharacterBody2D = component.get_me()

@export var hit_wall_state:BehaviorState

@export var MAX_SPEED:float = 300.0
@export var ACCELERATION:float = 23.0
@export var GRAVITY_MULTIPLIER:float = 1.0

func phys_active(delta:float):
	
	if not me.is_on_floor():
		me.velocity += GRAVITY_MULTIPLIER * me.get_gravity() * delta
	
	me.velocity.x = move_toward(me.velocity.x, MAX_SPEED, ACCELERATION * (60 * delta))

func active(_delta:float):
	if me.get_wall_normal().x < 0:
		component.change_state(hit_wall_state, me.velocity)
