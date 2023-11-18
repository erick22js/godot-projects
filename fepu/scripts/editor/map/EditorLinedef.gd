extends EditorElement
class_name EditorLinedef


# Properties
var p1:EditorPoint = null
var p2:EditorPoint = null

var sides:Array[EditorSidedef] = []

func _init():
	type = Type.LINEDEF
	pass
