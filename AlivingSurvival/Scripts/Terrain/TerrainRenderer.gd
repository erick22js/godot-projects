extends Spatial



func _ready():
	var st = SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	#add_smooth_group(true)
	# Prepare attributes for add_vertex.
	st.add_normal(Vector3(0, 0, 1))
	st.add_uv(Vector2(0, 0))
	st.add_uv2(Vector2(0,0))
	st.add_vertex(Vector3(-1, 0, -1))
	st.add_normal(Vector3(0, 0, 1))
	st.add_uv(Vector2(0, 1))
	st.add_uv2(Vector2(0,0))
	st.add_vertex(Vector3(1, 0, 1))
	st.add_normal(Vector3(0, 0, 1))
	st.add_uv(Vector2(1, 1))
	st.add_uv2(Vector2(0,0))
	st.add_vertex(Vector3(-1, 0, 1))
	
	st.add_normal(Vector3(0, 0, 1))
	st.add_uv(Vector2(0, 0))
	st.add_uv2(Vector2(0,0))
	st.add_vertex(Vector3(-1, 0, -1))
	st.add_normal(Vector3(0, 0, 1))
	st.add_uv(Vector2(1, 1))
	st.add_uv2(Vector2(0,0))
	st.add_vertex(Vector3(1, 0, -1))
	st.add_normal(Vector3(0, 0, 1))
	st.add_uv(Vector2(0, 1))
	st.add_uv2(Vector2(0,0))
	st.add_vertex(Vector3(1, 0, 1))
	# Create indices, indices are optional.
	st.index()
	# Commit to a mesh.
	var mesh = st.commit()
	$MeshInstance.mesh = mesh
	pass
