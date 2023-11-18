extends EditorElement
class_name EditorFacedef


# Properties
var hidden:bool = false
var side:EditorSidedef = null
var clockwise:bool = true

# Mesh Objects
var mesh:MeshInstance3D = null

func _init():
	type = Type.FACEDEF
	pass


#
#	Tests
#

func isCulled(from:Vector3)-> bool:
	var line := side.line
	var p1:Vector2 = (line.p1 if not clockwise else line.p2).pos
	var p2:Vector2 = (line.p2 if not clockwise else line.p1).pos
	return ((p2.x - p1.x)*(from.z - p1.y) - (p2.y - p1.y)*(from.x - p1.x)) < 0

func rayIntersects(from:Vector3, dir:Vector3):
	var line := side.line
	var p1:Vector2 = (line.p1 if not clockwise else line.p2).pos
	var p2:Vector2 = (line.p2 if not clockwise else line.p1).pos
	
	var if1 = Geometry3D.ray_intersects_triangle(from, dir,\
			mesh.position+Vector3(0, mesh.scale.y, 0), mesh.position+Vector3(p2.x-p1.x, mesh.scale.y, p2.y-p1.y), mesh.position+Vector3(p2.x-p1.x, 0, p2.y-p1.y))
	if if1: return if1
	var if2 = Geometry3D.ray_intersects_triangle(from, dir,\
			mesh.position+Vector3(0, mesh.scale.y, 0), mesh.position+Vector3(p2.x-p1.x, 0, p2.y-p1.y), mesh.position)
	if if2: return if2
	return null
