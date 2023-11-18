extends Node

var rng = RandomNumberGenerator.new();

func _init():
	rng.randomize()

func random(start:float, end:float)->float:
	return rand_range(start, end)
