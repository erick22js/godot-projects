extends Node2D


func _ready():
	pass # Replace with function body.

func _input(event):
	if event is InputEventScreenDrag:
		$camera.position -= event.relative/$camera.zoom
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP and $camera.zoom<Vector2(4.0, 4.0):
			$camera.zoom *= 1.1
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN and $camera.zoom>Vector2(0.4, 0.4):
			$camera.zoom *= 1.0/1.1
	pass

func _process(delta):
	pass
