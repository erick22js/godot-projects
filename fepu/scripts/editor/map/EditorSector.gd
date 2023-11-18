extends EditorElement
class_name EditorSector


# Properties
var lines:Array[EditorLinedef] = []
var path:Array[EditorPoint] = []

var sides:Array[EditorSidedef] = []

var floor_height:float = 0
var ceil_height:float = 128

# Mesh Objects
var mesh_floor:MeshInstance3D = null
var mesh_ceil:MeshInstance3D = null

func _init():
	type = Type.SECTOR
	pass
