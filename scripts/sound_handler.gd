extends Node
class_name SoundHandler

const MAX_CONCURRENT_SFX:int = 4

func make_new_sfx_player() -> AudioStreamPlayer2D:
	var new = AudioStreamPlayer2D.new()
	
	add_child(new)
	new.bus = "SFX"
	
	return new

func _on_play_sfx(sfx:AudioStream, at:Vector2):
	var sfx_players:Array[AudioStreamPlayer2D]
	
	for child in get_children():
		if child is AudioStreamPlayer2D:
			sfx_players.append(child)
			
			if not child.playing:
				child.stream = sfx
				child.global_position = at
				child.play()
				return 1 # Succeeded, used an existing player.
	
	if len(sfx_players) < MAX_CONCURRENT_SFX:
		var new_player:AudioStreamPlayer2D = make_new_sfx_player()
		
		new_player.stream = sfx
		new_player.global_position = at
		new_player.play()
		return 2 # Succeeded, made a new player.
	return 0 # Failed, no sound :(

func _ready() -> void:
	Global.play_sfx.connect(_on_play_sfx)
