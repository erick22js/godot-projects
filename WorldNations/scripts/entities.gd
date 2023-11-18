extends Node

var ent = null;

func addEntitie(type, data={}, x=0, y=0, angle=0):
	Data.entities.append({"type":type, "x":x, "y":y, "angle":angle, "data":data});

func updateEntity(entity, i):
	ent = entity;
	ent.index = i
	call(entity.type);
	pass

func ship():
	#print("ship");
	pass	
