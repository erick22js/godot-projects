extends EditorElement
class_name EditorSidedef


# Properties
var line:EditorLinedef = null
var faces:Array[EditorFacedef] = []
var right:bool = true

var sector:EditorSector = null

func _init():
	type = Type.SIDEDEF
	pass
