extends StaticBody

var surfT := SurfaceTool.new()
var mesh = null;
var meshInstance = null;
var chunk_position := Vector2()
var chunk_index := Vector2()

var blocks = []

var material = preload("res://Textures/TerrainMaterial.tres")

func _ready():
	material.albedo_texture.set_flags(2)
	updateChunk()

func updateChunk():
	if chunk_position.x<0 or chunk_position.x>=MapGenerator.MapChunksSize.x or chunk_position.x<0 or chunk_position.y>=MapGenerator.MapChunksSize.y:
		return
	blocks = Global.GChunks[chunk_position.x][chunk_position.y]
	mesh = Mesh.new()
	surfT.begin(Mesh.PRIMITIVE_TRIANGLES)
	for x in MapGenerator.chunkDimensions.x:
		for y in MapGenerator.chunkDimensions.y:
			for z in MapGenerator.chunkDimensions.x:
				createBlock(x, y, z)
	surfT.generate_normals()
	surfT.set_material(material)
	surfT.commit(mesh)
	if meshInstance!= null:
		meshInstance.call_deferred("queue_free")
		meshInstance = null
	meshInstance = MeshInstance.new()
	meshInstance.mesh = mesh
	add_child(meshInstance)
	meshInstance.create_trimesh_collision()
	#meshInstance.
	#meshInstance.

func checkTransparent(x:int, y:int, z:int):
	if x>=0 and x<MapGenerator.chunkDimensions.x and\
	   y>=0 and y<MapGenerator.chunkDimensions.y and\
	   z>=0 and z<MapGenerator.chunkDimensions.z:
		return not DataTypes.Blocks[blocks[x*MapGenerator.chunkDimensions.y*MapGenerator.chunkDimensions.z+y*MapGenerator.chunkDimensions.z+z]][DataTypes.SOLID]
	return true;

func createBlock(x:int, y:int, z:int):
	var block = blocks[x*MapGenerator.chunkDimensions.y*MapGenerator.chunkDimensions.z+y*MapGenerator.chunkDimensions.z+z]
	if block=="air":
		return
	var block_info = DataTypes.Blocks[block]
	
	if checkTransparent(x, y, z+1):
		createFace(ChunkUtils.cubeFaces.front, block_info[DataTypes.FRONT], x, y, z)
	if checkTransparent(x, y, z-1):
		createFace(ChunkUtils.cubeFaces.back, block_info[DataTypes.BACK], x, y, z)
	if checkTransparent(x-1, y, z):
		createFace(ChunkUtils.cubeFaces.left, block_info[DataTypes.LEFT], x, y, z)
	if checkTransparent(x+1, y, z):
		createFace(ChunkUtils.cubeFaces.right, block_info[DataTypes.RIGHT], x, y, z)
	if checkTransparent(x, y+1, z):
		createFace(ChunkUtils.cubeFaces.top, block_info[DataTypes.TOP], x, y, z)
	if checkTransparent(x, y-1, z):
		createFace(ChunkUtils.cubeFaces.bottom, block_info[DataTypes.BOTTOM], x, y, z)

func createFace(face, texFace:Vector2, x:int, y:int, z:int):
	var offset = Vector3(x, y, z)
	var a = ChunkUtils.cubeVertices[face[0]] + offset
	var b = ChunkUtils.cubeVertices[face[1]] + offset
	var c = ChunkUtils.cubeVertices[face[2]] + offset
	var d = ChunkUtils.cubeVertices[face[3]] + offset
	var uv_offset = texFace/Vector2(64,32)
	var uv_a = uv_offset + Vector2(0, 0)
	var uv_b = uv_offset + Vector2(0.015625, 0)
	var uv_c = uv_offset + Vector2(0.015625, 0.03125)
	var uv_d = uv_offset + Vector2(0, 0.03125)
	surfT.add_triangle_fan([a, b, c], [uv_a, uv_b, uv_c])
	surfT.add_triangle_fan([a, c, d], [uv_a, uv_c, uv_d])

func set_chunk_position(pos:Vector2):
	chunk_position = pos
	translation = Vector3(pos.x, 0, pos.y) * MapGenerator.chunkDimensions
