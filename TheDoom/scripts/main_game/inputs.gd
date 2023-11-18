extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var x = 0;
var y = 0;

var oldX = 0;
var oldY = 0;

var executing_mouse_look = false;
var use_mouse = OS.get_name()!="Android";

var mapInputs = {
	"move_dir":0,
	"move_int":0,
	"x":0,
	"z":0
}
var mapKeys = {};
var mapTouches = {};

# Called when the node enters the scene tree for the first time.
func _ready():
	var mouseP = get_viewport().get_mouse_position();
	oldX = mouseP.x;
	oldY = mouseP.y;
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if use_mouse:
		var mouseP = get_viewport().get_mouse_position();
		x = mouseP.x-oldX;
		y = mouseP.y-oldY;
		if executing_mouse_look:
			get_viewport().warp_mouse(Vector2(256, 160));
		oldX = 256;
		oldY = 160;
	else:
		pass
	pass

func _input(event):
	if event is InputEventKey:
		if event.pressed:
			mapKeys[event.scancode] = true;
#			match event.scancode:
#				KEY_W:
#					mapInputs.x = 1;
#					mapInputs.move_int = 1;
#				KEY_S:
#					mapInputs.x = -1;
#					mapInputs.move_int = 1;
#				KEY_D:
#					mapInputs.z = -1;
#					mapInputs.move_int = 1;
#				KEY_A:
#					mapInputs.z = 1;
#					mapInputs.move_int = 1;
		else:
			mapKeys[event.scancode] = false;
#			match event.scancode:
#				KEY_W:
#					mapInputs.x = 0;
#					mapInputs.move_int = 0;
#				KEY_S:
#					mapInputs.x = 0;
#					mapInputs.move_int = 0;
#				KEY_D:
#					mapInputs.z = 0;
#					mapInputs.move_int = 0;
#				KEY_A:
#					mapInputs.z = 0;
#					mapInputs.move_int = 0;
		pass
	mapInputs.move_dir = retrieve_move_direction();
	if event is InputEventScreenTouch:
		if event.pressed:
			mapTouches[event.index] = event;
		else:
			mapTouches[event.index] = event;
	if event is InputEventScreenDrag:
		mapTouches[event.index].position = event.position;
	pass

func key_pressed(index):
	return false if !mapKeys.has(index) else mapKeys[index];

func retrieve_move_direction():
	return atan2(mapInputs.z, mapInputs.x);
