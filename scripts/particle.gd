extends GPUParticles2D
class_name Particle

func _ready() -> void:
	emitting = true

func _on_finished() -> void:
	queue_free()
