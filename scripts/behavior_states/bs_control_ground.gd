extends BehaviorState
class_name GroundControlBehaviorState
@onready var me:CharacterBody2D = component.get_me()

@export var entered_water_state:BehaviorState

## Movement Variables
@export var INPUT_LEFT:String = "Left"
@export var INPUT_RIGHT:String = "Right"
@export var INPUT_JUMP:String = "Up"

@export var MOVEMENT_LOCKED:bool = false
@export var MAX_SPEED = 90.0

@export var ACCELERATION = 23.0
@export var AIR_ACCELERATION = 8.0

@export var FRICTION = 6.0
@export var AIR_FRICTION = 3.5

@export var JUMP_VELOCITY = -105.0

# Jump buffering / Coyote time
@export var COYOTE_TIME:float = 0.1
var coyote_time:float = 0.0

@export var JUMP_BUFFERING:float = 0.2
var jump_buffering:float = 0.0

# Wall jumping
@export var WALL_JUMP_VELOCITY:Vector2 = Vector2(MAX_SPEED,JUMP_VELOCITY) * 1.4

@export var WALL_JUMP_BUFFERING:float = 0.15
var wall_jump_buffering:float = 0.0

@export var LEFT_FLOOR_BUFFER:float = 0.1 # How long the player has to have been off the floor for them to stick to walls
var left_floor_buffer:float = 0.0

@export var SLIDE_ACCELERATION:float = 8.0
@export var SLIDE_SPEED:float = 30.0

@export var GRAVITY_MULTIPLIER:float = 0.23

var wall_side:float = 0.0

# Collision & Facing

var active_collision:Node2D
func set_active_collision(to:Node2D):
	if to is not CollisionPolygon2D and to is not CollisionShape2D or to == active_collision:
		return
	
	active_collision = to
	
	for child in get_children():
		if child is CollisionPolygon2D or child is CollisionShape2D:
			child.set_deferred("disabled", true)
	
	to.set_deferred("disabled", false)

func is_facing_left() -> bool:
	
	if me.get_wall_normal() != Vector2.ZERO:
		return (me.get_wall_normal().x + 1) / 2 > 0
	
	return me.velocity.x < 0

## Math and logic functions
func abs_highest(values:Array[float]) -> float:
	var abs_high = 0.0
	for value in values:
		if abs(value) > abs(abs_high):
			abs_high = value
	return abs_high

func is_positive(number:float) -> bool:
	return number / abs(number) > 0

# Match the value's sign to another value's sign (ie, 4, -10 -> -4)
func match_sign(value:float, to:float) -> float:
	if value == 0 or to == 0:
		return 0
	return abs(value) * (to/abs(to))

func xor(a:bool, b:bool) -> bool:
	return (a or b) and not (a and b)

func phys_active(delta: float):
	# Add the gravity.
	if not me.is_on_floor():
		me.velocity += GRAVITY_MULTIPLIER * me.get_gravity() * delta
	
	if not MOVEMENT_LOCKED:
		## Jumping 
		
		# Jump Buffering
		jump_buffering = move_toward(jump_buffering, 0, delta)
		if Input.is_action_just_pressed(INPUT_JUMP): #and Global.player_can_control:
			jump_buffering = JUMP_BUFFERING
		
		# Coyote Time (and the left_floor_buffer)
		coyote_time = move_toward(coyote_time, 0, delta)
		left_floor_buffer = move_toward(left_floor_buffer, 0, delta)
		if me.is_on_floor():
			coyote_time = COYOTE_TIME
			left_floor_buffer = LEFT_FLOOR_BUFFER
			
		
		# Handle jump.
		if jump_buffering > 0 and coyote_time > 0:
			#Global.play_sfx.emit(jump_sfx)
			me.velocity.y = JUMP_VELOCITY
			
			jump_buffering = 0
			coyote_time = 0
		
		## Wall Jumping
		
		wall_jump_buffering = move_toward(wall_jump_buffering, 0, delta)
		if me.is_on_wall_only() and left_floor_buffer == 0:
			wall_side = me.get_wall_normal().x
			
			# Slow down upwards momentum significantly
			if me.velocity.y < 0:
				me.velocity.y /= 1.1
			
			# Override the gravity with slide acceleration
			me.velocity.y -= GRAVITY_MULTIPLIER * me.get_gravity().y * delta
			me.velocity.y += SLIDE_ACCELERATION * delta
			
			# Cap the slide speed
			if me.velocity.y > SLIDE_SPEED:
				me.velocity.y = SLIDE_SPEED
			
			wall_jump_buffering = WALL_JUMP_BUFFERING
			
		if jump_buffering > 0 and wall_jump_buffering > 0:
			# Global.play_sfx.emit(jump_sfx)
			
			# Wall jump, applying the wall side as a multiplier to make the jump to the right side
			me.velocity = WALL_JUMP_VELOCITY * Vector2(wall_side, 1)
			jump_buffering = 0
		
		## Movement
		
		# Get the input direction
		var direction = Vector2(Input.get_axis(INPUT_LEFT, INPUT_RIGHT), 0)
		
		# If trying to move
		if direction: #and Global.player_can_control:
			
			# IF the direction the player is going and the direction they want to go are different things
			var is_trying_to_turn:bool = xor(is_positive(me.velocity.x), is_positive(direction.x))
			
			# The next x velocity is whichever value is further from 0 (highest when absolute)
			var next_x_velocity:float = abs_highest([direction.x * MAX_SPEED, me.velocity.x]) * 0.99
			
			var current_acceleration = ACCELERATION if me.is_on_floor() else AIR_ACCELERATION
			
			# Override the velocity if you're trying to turn
			if is_trying_to_turn:
				next_x_velocity = direction.x * MAX_SPEED
				
				# Make it even harder to turn while midair
				if not me.is_on_floor():
					current_acceleration /= AIR_FRICTION
			
			# Move velocity.x towards where it should 
			# be via the current acceleration.
			me.velocity.x = move_toward(me.velocity.x, next_x_velocity, current_acceleration * (delta * 60))
		# If not trying to move
		else:
			var current_friction:float = FRICTION if me.is_on_floor() else AIR_FRICTION
		
			# If not trying to move, slow down according to the current friction
			me.velocity.x = move_toward(me.velocity.x, 0, current_friction)
	else:
		var current_friction:float = FRICTION if me.is_on_floor() else AIR_FRICTION
		# If can't move, slow down towards zero.
		me.velocity.x = move_toward(me.velocity.x, 0, current_friction * (delta * 60))
	

func active(_delta:float):
	if component.actor.global_position.y + 128 > Global.water_level and entered_water_state != null:
		component.change_state(entered_water_state, me.velocity)
