extends Area2D
class_name RainParticle

var rain:Rain

var been_alive_for:float = 0.0

func randomize_scale():
	var particle_scale = randf_range(rain.particle_scale_range.x, rain.particle_scale_range.y)
	scale = Vector2(particle_scale, particle_scale)

func respawn(x_axis:bool = true, y_axis:bool = true):
	
	been_alive_for = 0
	
	var x_bound:Vector2 = Vector2(rain.get_camera_bounds().position.x - (rain.get_camera_bounds().size.x / 2) , rain.get_camera_bounds().position.x + (rain.get_camera_bounds().size.x / 2))
	var y_bound:Vector2 = Vector2(rain.get_camera_bounds().position.y - (rain.get_camera_bounds().size.y / 2) , rain.get_camera_bounds().position.y + (rain.get_camera_bounds().size.y / 2))
	
	
	if x_axis:
		global_position.x = randf_range(x_bound.x, x_bound.y)
	
		randomize_scale()
	if y_axis:
		
		# print(Global.water_level, " vs ", y_bound.x)
		if not Global.water_level < y_bound.x:
			while true:
				global_position.y = randf_range(y_bound.x, y_bound.y)
				if global_position.y < Global.water_level:
					break
		randomize_scale()

var hit_particle:PackedScene = load("res://assets/tres/rain_hit_particle.tscn")
func spawn_hit_particles(chance:float, at:Vector2):
	if randf() < chance and been_alive_for > 0.4:
		Global.spawn_particle.emit(hit_particle.instantiate(), at)

func _process(delta: float) -> void:
	
	been_alive_for += delta
	
	if global_position.y + 32 > Global.water_level:
		spawn_hit_particles(0.7, global_position)
		respawn()
	
	var camera_bounds:Rect2 = rain.get_camera_bounds()
	
	var x_bound:Vector2 = Vector2(camera_bounds.position.x - (camera_bounds.size.x / 2) , camera_bounds.position.x + (camera_bounds.size.x / 2))
	var y_bound:Vector2 = Vector2(camera_bounds.position.y - (camera_bounds.size.y / 2) , camera_bounds.position.y + (camera_bounds.size.y / 2))
	
	if not Global.water_level < y_bound.x:
		var closest_block:RainBlock = rain.get_nearest_block(global_position)
		modulate.a = closest_block.get_opacity(global_position) if closest_block != null else 1.0
		
		self_modulate.a = move_toward(self_modulate.a, 1, delta*10)
		
		look_at(global_position + rain.particle_velocity)
		global_position += rain.particle_velocity * 60 * delta
		
		
		var x_wrap = wrap(global_position.x, x_bound.x, x_bound.y)
		var y_wrap = wrap(global_position.y, y_bound.x, y_bound.y)
		if global_position.x - x_wrap != 0:
			respawn(false, true)
		if global_position.y - y_wrap != 0:
			respawn(true, false)
			
			randomize_scale()
		
		global_position.x = wrap(global_position.x, x_bound.x, x_bound.y)
		global_position.y = wrap(global_position.y, y_bound.x, y_bound.y)
		visible = true
	else:
		visible = false
#
#func _on_body_entered(body: Node2D) -> void:
	#if body is TileMapLayer:
		#spawn_hit_particles(0.2, global_position - Vector2(0, 128))
		#respawn()
		#
