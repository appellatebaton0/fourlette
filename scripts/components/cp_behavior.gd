# Component Setup
extends Component
class_name BehaviorComponent
func get_id() -> String:
	return "BehaviorComponent"
var me:CharacterBody2D = get_me()

signal changed_state(to:BehaviorState)

@onready var states:Array[BehaviorState] = get_states()
func get_states() -> Array[BehaviorState]:
	var return_states:Array[BehaviorState]
	
	for child in get_children():
		if child is BehaviorState:
			return_states.append(child)
			
	return return_states
func change_state(to:BehaviorState, carry_velocity:Vector2 = Vector2.ZERO):
	if to == null:
		return
	
	current_state.on_inactive()
	current_state = to
	if carry_velocity != Vector2.ZERO and to.me is CharacterBody2D:
		to.me.velocity = carry_velocity
	current_state.on_active()
	
	changed_state.emit(to)


@export var current_state:BehaviorState

func take_knockback(from:Actor, amount:float):
	if amount == 0:
		return
	me.velocity += from.global_position.direction_to(actor.global_position) * amount

func _ready() -> void:
	current_state.on_active()

func _process(delta: float) -> void:
	for state in states:
		if state == current_state:
			state.active(delta)
		else:
			state.inactive(delta)
func _physics_process(delta: float) -> void:
	for state in states:
		if state == current_state:
			state.phys_active(delta)
		else:
			state.phys_inactive(delta)
	
	me.move_and_slide()
	
	# Move the actor as you should
	actor.global_position = me.global_position
	me.position = Vector2.ZERO
