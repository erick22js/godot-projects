#@tool
extends Node3D

# Called when the node enters the scene tree for the first time.
func _ready():
	#var mm = DoomLegacy.loadWadMap("C:/Users/Erick/Documents/MeusProjetos/Godot/Fepu/DOOM.WAD", "E1M1")
	var map = Map.new(Database.map)
	
	var bd := MapBuilder.new()
	var inst := bd.commit(map)
	
	print("Wellu?")
	
	for it in inst:
		self.add_child(it)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
