extends Node
class_name MapBuilder


var shader_wall := preload("res://shader/map/Wall.gdshader")
var shader_flat := preload("res://shader/map/Flat.gdshader")


# Properties
var map:Map = null

func _init():
	pass

func _buildAttribWallMaterial(color:Color)-> ShaderMaterial:
	var material = ShaderMaterial.new()
	material.shader = shader_wall
	material.set_shader_parameter("color", color)
	material.set_shader_parameter("tex", preload("res://textures/tile.png"))
	return material

func _buildAttribFlatMaterial(color:Color)-> ShaderMaterial:
	var material = ShaderMaterial.new()
	material.shader = shader_flat
	material.set_shader_parameter("color", color)
	material.set_shader_parameter("tex", preload("res://textures/tile.png"))
	return material

func _buildInstanceFromFace(face:Facedef)-> MeshInstance3D:
	var side := face.side
	var line := side.line
	var sector := side.ssector
	
	var p1:Vector2 = line.p1 if side.right else line.p2
	var p2:Vector2 = line.p2 if side.right else line.p1
	
	var instance := MeshInstance3D.new()
	var a_mesh := ArrayMesh.new()
	
	var data = []
	data.resize(Mesh.ARRAY_MAX)
	data[Mesh.ARRAY_VERTEX] = PackedVector3Array([
		Vector3(p1.x, face.upper_h, p1.y),
		Vector3(p2.x, face.upper_h, p2.y),
		Vector3(p2.x, face.lower_h, p2.y),
		Vector3(p1.x, face.lower_h, p1.y)
	])
	data[Mesh.ARRAY_TEX_UV] = PackedVector2Array([
		Vector2(0, face.upper_h),
		Vector2(p1.distance_to(p2), face.upper_h),
		Vector2(p1.distance_to(p2), face.lower_h),
		Vector2(0, face.lower_h)
	])
	data[Mesh.ARRAY_INDEX] = PackedInt32Array([
		0, 1, 2,
		0, 2, 3
	])
	a_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, data)
	
	instance.mesh = a_mesh
	instance.visible = (not face.hidden) and face.upper_h > face.lower_h
	return instance

func _buildInstancesFromSide(side:Sidedef)-> Array[MeshInstance3D]:
	var line := side.line
	var sector := side.ssector.sector
	
	var instances:Array[MeshInstance3D] = []
	
	# Update faces size
	# Setup for only face
	if side.faces.size() == 1:
		side.faces[0].lower_h = sector.floor_height
		side.faces[0].upper_h = sector.ceil_height
	# Setup for portal faces and non portal
	var lower_base = sector.floor_height
	for face in side.faces:
		if face.portal != null:
			face.lower_h = sector.floor_height if\
				sector.floor_height > face.portal.sector.floor_height else\
				face.portal.sector.floor_height
			face.upper_h = sector.ceil_height if\
				sector.ceil_height < face.portal.sector.ceil_height else\
				face.portal.sector.ceil_height
			lower_base = face.portal.sector.ceil_height
		else:
			face.lower_h = lower_base
			face.upper_h = lower_base
	# Join faces to nearest face
	for f in side.faces.size():
		var face = side.faces[f]
		if face.portal == null:
			if f == (side.faces.size()-1):
				face.upper_h = sector.ceil_height
			else:
				var nface = side.faces[f+1]
				face.upper_h = nface.lower_h
	
	# Generate faces instances
	for face in side.faces:
		var instance := _buildInstanceFromFace(face)
		instance.material_overlay = _buildAttribWallMaterial(\
			Color(0, .9, 0, 1) if face.portal != null else Color(0, .5, 0, 1))
		instances.push_back(
			instance
		)
	return instances

func _buildInstancesFromSectorFloor(ssector:Subsector)-> MeshInstance3D:
	var instance := MeshInstance3D.new()
	
	var a_mesh := ArrayMesh.new()
	
	var vertices := PackedVector3Array()
	var uvs := PackedVector2Array()
	var indices := PackedInt32Array()
	for point in ssector.shape:
		vertices.push_back(Vector3(point.x, ssector.sector.floor_height, point.y))
		uvs.push_back(Vector2(point.x, point.y))
	
	var _ind := 0
	for point in ssector.shape:
		var ind = _ind
		if _ind > 1:
			if ind&1:
				ind = (ind>>1) + 1
			else:
				ind = ssector.shape.size() - (ind>>1)
		indices.push_back(ind); _ind += 1
	
	var data = []
	data.resize(Mesh.ARRAY_MAX)
	data[Mesh.ARRAY_VERTEX] = vertices
	data[Mesh.ARRAY_TEX_UV] = uvs
	data[Mesh.ARRAY_INDEX] = indices
	a_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLE_STRIP, data)
	
	instance.mesh = a_mesh
	instance.material_overlay = _buildAttribFlatMaterial(Color(1, 0, 0, 1))
	
	return instance

func _buildInstancesFromSectorCeil(ssector:Subsector)-> MeshInstance3D:
	var instance := MeshInstance3D.new()
	
	var a_mesh := ArrayMesh.new()
	
	var vertices := PackedVector3Array()
	var uvs := PackedVector2Array()
	var indices := PackedInt32Array()
	for point in ssector.shape:
		vertices.push_back(Vector3(point.x, ssector.sector.ceil_height, point.y))
		uvs.push_back(Vector2(point.x, point.y))
	
	var _ind := 0
	for point in ssector.shape:
		var ind = _ind
		if _ind > 1:
			if ind&1:
				ind = ssector.shape.size() - (ind>>1)
			else:
				ind = (ind>>1) + 1
		else:
			ind = 1 - ind
		indices.push_back(ind); _ind += 1
	
	var data = []
	data.resize(Mesh.ARRAY_MAX)
	data[Mesh.ARRAY_VERTEX] = vertices
	data[Mesh.ARRAY_TEX_UV] = uvs
	data[Mesh.ARRAY_INDEX] = indices
	a_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLE_STRIP, data)
	
	instance.mesh = a_mesh
	instance.material_overlay = _buildAttribFlatMaterial(Color(0, 0, 1, 1))
	
	return instance

func commit(map:Map)-> Array[MeshInstance3D]:
	self.map = map
	var instances:Array[MeshInstance3D] = []
	
	# Iterate over each sector and generate meshs
	for sector in map.sectors:
		for ssector in sector.ssectors:
			for side in ssector.sides:
				instances.append_array(
					_buildInstancesFromSide(side)
				)
			instances.push_back(
				_buildInstancesFromSectorFloor(ssector)
			)
			instances.push_back(
				_buildInstancesFromSectorCeil(ssector)
			)
		pass
	
	return instances

