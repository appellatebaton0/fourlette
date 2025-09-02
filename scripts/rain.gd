extends Node2D
class_name Rain

@export var particle_count:int = 100
@export var interparticle_delay:float = 0.0

@export var particle_velocity:Vector2 = Vector2(-1, 1)

@onready var camera:Camera = get_tree().get_first_node_in_group("Camera")

@onready var rain_particle:Sprite2D = $Sprite2D
@export var rain_atlas:AtlasTexture
@onready var rain_atlas_indices:int

@export var rain_blocks:Array[RainBlock]
@export var particle_scale_range:Vector2 = Vector2(1,1)


const RAIN_TEXTURE_RESOLUTION:int = 64

func get_camera_bounds() -> Rect2:
	var answer = get_viewport_rect()
	answer.position += camera.global_position
	
	answer.size /= camera.zoom
	
	answer.size *= 1.2
	
	return answer

var rain_scene:PackedScene = load("res://scenes/rain_particle.tscn")

func get_new_rain_particle() -> RainParticle:
	var new_particle:RainParticle = rain_scene.instantiate()
	add_child(new_particle)
	
	new_particle.rain = self
	
	new_particle.self_modulate.a = 0.0
	var particle_scale = randf_range(particle_scale_range.x, particle_scale_range.y)
	new_particle.scale = Vector2(particle_scale, particle_scale)
	#
	#var texture:AtlasTexture = rain_atlas.duplicate()
	#texture.region.position = Vector2(0, randi_range(0, rain_atlas_indices) * RAIN_TEXTURE_RESOLUTION)
	#
	#new_particle.texture = texture
	#
	return new_particle

func get_nearest_block(point:Vector2) -> RainBlock:
	var nearest_block:RainBlock
	
	for block in rain_blocks:
		if nearest_block == null or nearest_block.global_position.distance_to(point) > block.global_position.distance_to(point):
			nearest_block = block
	return nearest_block

var particle_data:Dictionary

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rain_atlas_indices = rain_atlas.atlas.get_height() / rain_atlas.region.size.y
	rain_particle.texture = rain_atlas.duplicate()
	rain_particle.self_modulate.a = 0.0
	var particle_scale = randf_range(particle_scale_range.x, particle_scale_range.y)
	rain_particle.scale = Vector2(particle_scale, particle_scale)
	particle_data[rain_particle] = randf()
	
	var blocks = get_tree().get_nodes_in_group("SnowBlock")
	for block in blocks:
		if block is RainBlock:
			rain_blocks.append(block)
	
	var camera_bounds:Rect2 = get_camera_bounds()
	var x_bound:Vector2 = Vector2(camera_bounds.position.x - (camera_bounds.size.x / 2) , camera_bounds.position.x + (camera_bounds.size.x / 2))
	var y_bound:Vector2 = Vector2(camera_bounds.position.y - (camera_bounds.size.y / 2) , camera_bounds.position.y + (camera_bounds.size.y / 2))
	
	for i in range(particle_count):
		var new:RainParticle = get_new_rain_particle()
		particle_data[new] = (randf() - 0.5)
		new.global_position = Vector2(randf_range(x_bound.x, x_bound.y),randf_range(y_bound.x, y_bound.y))
