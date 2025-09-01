extends Control
class_name FadeOverlay

signal fully_faded

var progress:float = 0.0
var switch:bool = false
var signal_emitted = false

@export var START_TIME:float = 1.0 # How long to wait before starting to fade
@export var FADE_TIME:float = 1.0 # How long fading in/out takes
@export var PAUSE_TIME:float = 1.0 # How long to pause once fully faded before fading out

var fade_time:float = 0.0

func start():
	switch = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	# Manage the fading.
	if switch:
		fade_time = move_toward(fade_time, START_TIME + FADE_TIME + PAUSE_TIME + FADE_TIME, delta)
		
		# IF past the start buffer and before the end of the fade, fade out.
		if fade_time > START_TIME and fade_time < START_TIME + FADE_TIME:
			progress = (fade_time - START_TIME) / FADE_TIME
		# IF past the start, fade out, and pause buffers, fade in.
		elif fade_time - START_TIME - FADE_TIME > PAUSE_TIME:
			progress = 1.0 - ((fade_time - START_TIME - FADE_TIME - PAUSE_TIME) / FADE_TIME)
		
		# Emit the response signal once fully faded.
		if fade_time >= START_TIME + FADE_TIME and not signal_emitted:
			fully_faded.emit()
			signal_emitted = true
		
		if fade_time >= START_TIME + FADE_TIME + PAUSE_TIME + FADE_TIME:
			switch = false
	else:
		fade_time = 0.0
		signal_emitted = false
	
	# Match the shader variable to the code variable.
	material.set_shader_parameter("progress", progress)
