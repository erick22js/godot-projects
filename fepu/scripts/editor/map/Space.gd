extends Node3D


var shader_wall := preload("res://shader/map/Wall.gdshader")
var shader_flat := preload("res://shader/map/Flat.gdshader")
var shader_highlight := preload("res://shader/map/Highlight.gdshader")

# Properties
var map:EditorMap = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if map:
		var viewer = get_parent().get_node("Viewer")
		var axys := Vector3.FORWARD
		axys = axys.rotated(Vector3.RIGHT, viewer.rotation.x)
		axys = axys.rotated(Vector3.UP, viewer.rotation.y)
		var closest_face:EditorFacedef = null
		var closest_dis:float = INF
		
		for se in map.sectors:
			for si in se.sides:
				for f in si.faces:
					f.mesh.material_overlay.set_shader_parameter("enabled", false)
					if not f.isCulled(viewer.position):
						var inter = f.rayIntersects(viewer.position, axys)
						if inter and inter.distance_to(viewer.position) < closest_dis:
							closest_face = f
							closest_dis = inter.distance_to(viewer.position)
		if closest_face:
			closest_face.mesh.material_overlay.set_shader_parameter("enabled", true)
	pass

func _init():
	pass

#
#	MATERIAL HANDLING METHODS
#

func _buildAttribHighlightMaterial()-> ShaderMaterial:
	var material = ShaderMaterial.new()
	material.shader = shader_highlight
	return material

func _buildAttribWallMaterial(color:Color, color_bottom_stop:float, color_top_stop:float, color_bottom:Color, color_top:Color)-> ShaderMaterial:
	var material = ShaderMaterial.new()
	material.shader = shader_wall
	material.set_shader_parameter("color", color)
	material.set_shader_parameter("color_top_stop", color_top_stop)
	material.set_shader_parameter("color_bottom_stop", color_bottom_stop)
	material.set_shader_parameter("color_top", color_top)
	material.set_shader_parameter("color_bottom", color_bottom)
	material.set_shader_parameter("tex", preload("res://textures/tile.png"))
	return material

func _buildAttribFlatMaterial(color:Color)-> ShaderMaterial:
	var material = ShaderMaterial.new()
	material.shader = shader_flat
	material.set_shader_parameter("color", color)
	material.set_shader_parameter("tex", preload("res://textures/tile.png"))
	return material

#
#	UTILITIES
#

func _triangulateSectorShape(shape:Array[EditorPoint], inverse:bool = false)-> PackedInt32Array:
	var poly := PackedVector2Array()
	for p in shape:
		poly.push_back(p.pos)
	var indices:PackedInt32Array = Geometry2D.triangulate_polygon(poly)
	if inverse:
		var i:int = 0
		while i < indices.size():
			var i1 := indices[i]
			var i2 := indices[i+1]
			indices[i] = i2
			indices[i+1] = i1
			i += 3
	return indices

#
#	MESH BUILDING METHODS
#

func _buildInstanceFromFace(face:EditorFacedef, clockwise:bool)-> MeshInstance3D:
	var side := face.side
	var line := side.line
	var sector := side.sector
	
	clockwise = side.right == clockwise
	face.clockwise = clockwise
	var p1:Vector2 = (line.p1 if not clockwise else line.p2).pos
	var p2:Vector2 = (line.p2 if not clockwise else line.p1).pos
	
	var instance := MeshInstance3D.new()
	var a_mesh := ArrayMesh.new()
	
	var data = []
	data.resize(Mesh.ARRAY_MAX)
	data[Mesh.ARRAY_VERTEX] = PackedVector3Array([
		Vector3(0, 1, 0),
		Vector3(p2.x-p1.x, 1, p2.y-p1.y),
		Vector3(p2.x-p1.x, 0, p2.y-p1.y),
		Vector3(0, 0, 0)
	])
	data[Mesh.ARRAY_INDEX] = PackedInt32Array([
		0, 1, 2,
		0, 2, 3
	])
	a_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, data)
	
	instance.mesh = a_mesh
	instance.visible = (not face.hidden) and 72 > 0
	instance.position = Vector3(p1.x, sector.floor_height, p1.y)
	instance.scale.y = sector.ceil_height - sector.floor_height
	return instance

func _buildInstancesFromSide(side:EditorSidedef, clockwise:bool)-> Array[MeshInstance3D]:
	var line := side.line
	var sector := side.sector
	
	var instances:Array[MeshInstance3D] = []
	"""
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
	"""
	# Generate faces instances
	for face in side.faces:
		var instance := _buildInstanceFromFace(face, clockwise)
		instance.material_override = _buildAttribWallMaterial(\
			Color(0, .9, 0, 1) if false else Color(0, .5, 0, 1),
			sector.floor_height, sector.ceil_height, Color(0, 0, 0), Color(1, 1, 1))
		instance.material_overlay = _buildAttribHighlightMaterial()
		instances.push_back(
			instance
		)
		face.mesh = instance
	return instances

func _buildInstancesFromSectorFloor(sector:EditorSector)-> MeshInstance3D:
	var instance := MeshInstance3D.new()
	
	var a_mesh := ArrayMesh.new()
	
	var vertices := PackedVector3Array()
	for point in sector.path:
		vertices.push_back(Vector3(point.pos.x, 0, point.pos.y))
	
	var data = []
	data.resize(Mesh.ARRAY_MAX)
	data[Mesh.ARRAY_VERTEX] = vertices
	data[Mesh.ARRAY_INDEX] = _triangulateSectorShape(sector.path, false)
	a_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, data)
	
	instance.mesh = a_mesh
	instance.material_override = _buildAttribFlatMaterial(Color(1, 0, 0, 1))
	instance.material_overlay = _buildAttribHighlightMaterial()
	instance.position.y = sector.floor_height
	sector.mesh_floor = instance
	
	return instance

func _buildInstancesFromSectorCeil(sector:EditorSector)-> MeshInstance3D:
	var instance := MeshInstance3D.new()
	
	var a_mesh := ArrayMesh.new()
	
	var vertices := PackedVector3Array()
	for point in sector.path:
		vertices.push_back(Vector3(point.pos.x, 0, point.pos.y))
	
	var data = []
	data.resize(Mesh.ARRAY_MAX)
	data[Mesh.ARRAY_VERTEX] = vertices
	data[Mesh.ARRAY_INDEX] = _triangulateSectorShape(sector.path, true)
	a_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, data)
	
	instance.mesh = a_mesh
	instance.material_override = _buildAttribFlatMaterial(Color(0, 0, 1, 1))
	instance.material_overlay = _buildAttribHighlightMaterial()
	instance.position.y = sector.ceil_height
	sector.mesh_ceil = instance
	
	return instance

#
#	PUBLIC CONTROL METHODS
#

func commit(map:EditorMap):
	self.map = map
	var instances:Array[MeshInstance3D] = []
	
	# Iterate over each sector and generate meshs
	for sector in map.sectors:
		# Calculate Sector direction
		var shape := PackedVector2Array()
		for p in sector.path:
			shape.push_back(p.pos)
		var clockwise := Geometry2D.is_polygon_clockwise(shape)
		
		# Generate Sides Meshes
		for side in sector.sides:
			instances.append_array(
				_buildInstancesFromSide(side, clockwise)
			)
		
		# Generate Floor Mesh
		instances.push_back(
			_buildInstancesFromSectorFloor(sector)
		)
		
		# Generate Ceil Mesh
		instances.push_back(
			_buildInstancesFromSectorCeil(sector)
		)
		pass
	
	# Clear all current added children
	var ch := self.get_children()
	for c in ch:
		self.remove_child(c)
	
	# Insert all new children
	for inst in instances:
		self.add_child(inst)
