extends Node2D


####################################################################
#
# SYSTEM FUNCTIONS
#
####################################################################

func _ready():
	pass


func _process(delta):
	
	
	
	pass

func _input(event):
	if event is InputEventMouseButton:
		process_gesture(ACTION_DOWN if event.pressed else ACTION_UP, event.position.x, event.position.y)
	elif event is InputEventMouseMotion:
		process_gesture(ACTION_MOTION, event.position.x, event.position.y)
	elif event is InputEventScreenTouch:
		process_gesture(ACTION_DOWN if event.pressed else ACTION_UP, 0, 0)
	pass


####################################################################
#
# MODULE FUNCTIONS
#
####################################################################

const ACTION_DOWN := 0
const ACTION_UP := 1
const ACTION_MOTION := 2

func process_gesture(action:int, x:float, y:float):
	if action==ACTION_DOWN:
		$_player_aim.set_rotation(atan2(
			y-$_player_aim.rect_position.y,
			x-$_player_aim.rect_position.x
		))
	print("Shoots at ["+str(x)+", "+str(y)+"] state: "+str(action));
	pass
