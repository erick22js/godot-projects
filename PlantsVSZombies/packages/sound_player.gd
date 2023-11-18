extends AudioStreamPlayer

var play_flag = false;

func _ready():
	pass

func _process(delta):
	if playing and !play_flag:
		Util.present_songs += 1;
	elif !playing and play_flag:
		Util.present_songs -= 1;
	#print(Util.present_songs)
	play_flag = playing;
	volume_db = -Util.present_songs;

func deactivate_audio():
	#Util.present_songs -= 1;
	pass
