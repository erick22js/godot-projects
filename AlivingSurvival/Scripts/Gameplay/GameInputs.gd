extends Node

const Actions = {
	"vertical": 0,
	"horizontal": 0,
}
const Keys = {
	KEY_W: false,
	KEY_D: false,
	KEY_A: false,
	KEY_S: false,
}

func _ready():
	pass

func _process(delta):
	Actions["vertical"] = (-1 if Keys[KEY_W] else 0)+(1 if Keys[KEY_S] else 0)
	Actions["horizontal"] = (-1 if Keys[KEY_A] else 0)+(1 if Keys[KEY_D] else 0)
	pass

func _input(event):
	if(event is InputEventKey):
		Keys[event.scancode] = event.pressed;
	pass
