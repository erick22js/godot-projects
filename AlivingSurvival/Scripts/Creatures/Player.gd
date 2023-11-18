extends Node2D

export var valor:int;

func _ready():
	
	pass


func _process(delta):
	self.position += Vector2(GameInputs.Actions.horizontal, GameInputs.Actions.vertical)
	pass
