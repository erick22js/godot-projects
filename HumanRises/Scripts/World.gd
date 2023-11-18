extends Spatial



# Called when the node enters the scene tree for the first time.
func _ready():
	generateTerrain()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func generateTerrain():
	var mesh:Mesh = Mesh.new();
	var vertices:PoolVector3Array = PoolVector3Array();
	var uvs:PoolVector2Array = PoolVector2Array();
	
	vertices.push_back(Vector3(-10, 0, -10))
	vertices.push_back(Vector3(-10, 0, 10))
	vertices.push_back(Vector3(10, 0, 10))
	
	var surfTool:SurfaceTool = SurfaceTool.new()
	surfTool.begin(Mesh.PRIMITIVE_TRIANGLES)
	
	surfTool.add_vertex(vertices[0])
	surfTool.add_vertex(vertices[1])
	surfTool.add_vertex(vertices[2])
	
#	surfTool.add_normal(Vector3(0, 0, 1));
#	surfTool.add_uv(Vector2(0, 0));
#	surfTool.add_vertex(Vector3(-10, -10, 0));
#
#	surfTool.add_normal(Vector3(0, 0, 1));
#	surfTool.add_uv(Vector2(0, 0));
#	surfTool.add_vertex(Vector3(-10, -10, 0));
#
#	surfTool.add_normal(Vector3(0, 0, 1));
#	surfTool.add_uv(Vector2(0, 0));
#	surfTool.add_vertex(Vector3(10, 10, 0));
#
	surfTool.index()
	
	mesh = surfTool.commit()
	#mesh.surface_set_material(0, $Terrain.material_override)
	$Terrain.mesh = mesh
	print("Terrain generated!")

