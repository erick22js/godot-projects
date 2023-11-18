extends Node


var mouse := {
	"position": Vector2(),
	"_motion": Vector2(),
	"motion": Vector2(),
	"button": [false, false, false]
}
var keys := {}


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	pass # Replace with function body.

func _input(event):
	if event is InputEventKey:
		keys[event.scancode] = event.pressed
		pass
	if event is InputEventMouseButton:
		mouse["position"] = event.position
		mouse["button"][event.button_index] = event.pressed
		pass
	if event is InputEventMouseMotion:
		mouse["position"] = event.position
		mouse["_motion"] = event.relative
		pass
	pass

func _process(delta):
	mouse["motion"] = mouse["_motion"]
	mouse["_motion"] = Vector3()
	pass


#
#	UTILITY FUNCTIONS
#

func getKey(code:int)->bool:
	return false if !keys.has(code) else keys[code]
