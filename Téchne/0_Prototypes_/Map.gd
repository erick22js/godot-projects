extends Node

tool

func _ready():
	$MeshInstance2D.mesh = generateMesh()
	#$MeshInstance2D
	pass # Replace with function body.

func generateMesh()->Mesh:
	var st := SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	st.add_vertex(Vector3(0, 0, 0))
	st.add_color(Color(1.0, 0.0, 0.0))
	st.add_vertex(Vector3(80, 0, 0))
	st.add_color(Color(1.0, 0.0, 0.0))
	st.add_vertex(Vector3(80, 80, 0))
	st.add_color(Color(1.0, 0.0, 0.0))
	st.add_vertex(Vector3(0, 80, 0))
	st.add_color(Color(1.0, 0.0, 0.0))
	st.add_index(0)
	st.add_index(1)
	st.add_index(2)
	st.add_index(0)
	st.add_index(2)
	st.add_index(3)
	return st.commit()

func _process(delta):
	
	pass
