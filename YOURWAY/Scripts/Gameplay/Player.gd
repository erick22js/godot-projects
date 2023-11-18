extends Node

export (NodePath)var control;

# Called when the node enters the scene tree for the first time.
func _ready():
	control = get_node(control)
	pass # Replace with function body.

func _process(delta):
	if Settings.gameFreeze:
		return
	self.position.x += control.Keys.horizontal
	self.position.y += control.Keys.vertical
	pass
