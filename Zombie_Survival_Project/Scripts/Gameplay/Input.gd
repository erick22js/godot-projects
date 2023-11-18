extends Node

const keys = {}
const keysCheck = {}

const mouse = {
	"lock": true,
	"x": 0,
	"y": 0,
	"_oldx": 0,
	"_oldy": 0,
	"mx": 0,
	"my": 0,
}

func _process(delta):
	var mouseViewport = get_viewport().get_mouse_position()
	mouse.x = mouseViewport.x
	mouse.y = mouseViewport.y
	if mouse.lock:
		#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		get_viewport().warp_mouse(Vector2(256, 160))
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		mouse.mx = mouse._oldx-256
		mouse.my = mouse._oldy-160
	else:
		mouse.mx = mouse.x-mouse._oldx
		mouse.my = mouse.y-mouse._oldy
	mouse._oldx = mouse.x
	mouse._oldy = mouse.y
	for i in keys.keys():
		if keysCheck.has(i):
			keysCheck[i]["check2"] = keysCheck[i]["check1"]
			keysCheck[i]["check1"] = keys[i]
		else:
			keysCheck[i] = {"check1":keys[i], "check2":false}
	pass

func _input(event):
	#if event is InputEventMouseMotion:
	#	mouse.x = event.position.x
	#	mouse.y = event.position.y
	#	mouse.mx = event.speed.x
	#	mouse.my = event.speed.y
	#	print(event.speed)
	if(event is InputEventKey):
		setKey(event.scancode, event.pressed)
	pass

func setKey(key:int, mode:bool):
	keys[key] = mode

func getKey(key:int):
	return false if !keys.has(key) else keys[key]

func getKeyOnce(key:int):
	return  false if !keysCheck.has(key) else keysCheck[key]["check1"] and (not keysCheck[key]["check2"])
