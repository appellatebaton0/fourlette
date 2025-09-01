extends Camera2D
class_name Camera

@export var player:Actor
@onready var player_character:CharacterBody2D = player.get_component("BehaviorComponent").me

# @onready var player_controller:ControlComponent = player.get_component("MotionComponent")

@export var normal_zoom:Vector2 = Vector2(0.2, 0.2)
@export var day_start_zoom:Vector2 = Vector2(0.175, 0.175)

@export var follow_ahead:Vector2 = Vector2.ONE ## The multiplier on how far the camera follows ahead of the player.
@export var follow_lerp:float = 0.1 ## How fast the camera follows the player, 0 being not at all, 1 being instant.

var has_started_moving:bool = false

func get_follow_point() -> Vector2:
	
	if player == null:
		return global_position
	
	# Set the follow point to the player's position
	var player_point:Vector2 = player.global_position
	
	# Add the velocity with a dampener for some simple follow-ahead
	player_point += player_character.velocity * follow_ahead
	
	# Lerp between the current position and the player point.
	var follow_point = lerp(global_position, player_point, follow_lerp)
	
	return follow_point

func _ready() -> void:
	Global.day_ended.connect(_on_day_ended)

func _process(delta: float) -> void:
	if player_character.velocity != Vector2.ZERO:
		has_started_moving = true
	if has_started_moving:
		zoom.x = lerp(zoom.x, normal_zoom.x, 0.04)
		zoom.y = lerp(zoom.x, normal_zoom.x, 0.04)
	global_position = get_follow_point()

func _on_day_ended(depth:int):
	if depth != 1:
		return
	zoom = day_start_zoom
	has_started_moving = false
