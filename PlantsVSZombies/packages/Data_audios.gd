extends Node

###############Loading Sounds Streams##########################

const STREAMS = {
	"shoot1":"plants/shoot1.ogg",
	"shoot2":"plants/shoot2.ogg",
	"hit1":"zombies/hit1.ogg",
	"hit2":"zombies/hit2.ogg",
	"hit3":"zombies/hit3.ogg",
};


func _ready():
	for k in STREAMS.keys():
		#var audio =  AudioStreamOGGVorbis.new();
		##audio.
		AudioStreamOGGVorbis.new()
		STREAMS[k] = load("res://Sounds/"+STREAMS[k]);
	pass
