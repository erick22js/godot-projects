extends Area2D

func _ready():
	pass # Replace with function body.

func _process(delta):
	pass

func getEntity():
	return self.get_parent().get_parent();
