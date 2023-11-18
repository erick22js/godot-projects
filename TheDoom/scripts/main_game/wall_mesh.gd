extends MeshInstance


var end_vertex = Vector3(0, 0, 0);

var sector = null;
var material = load("res://shaders/wall.tres")
var material_sky = load("res://shaders/background_sky.tres")

var handle_heig = null;
var wall = null;
var sec_index = null;

var sky = false;

func _ready():
	if sky:
		self.material_override = material_sky.duplicate(false);
	else:
		self.material_override = material.duplicate(false);
		var sector = GlobalData.Map.sector[sec_index];
		self.material_override.set_shader_param("texture_scale",Vector2(2,2));
		self.material_override.set_shader_param("m_color", Color(sector.color[0],sector.color[1],sector.color[2],sector.color[3]));
		self.material_override.set_shader_param("fog_color",Color(sector.colorFog[0],sector.colorFog[1],sector.colorFog[2],sector.colorFog[3]))
		self.material_override.set_shader_param("fog_distance",sector.distanceFogMax/64.0);
		self.material_override.set_shader_param("tex",GlobalData.Textures[wall.textureM if handle_heig=="middler" else (wall.textureD if handle_heig=="downer" else wall.textureU)]);
	
	load_struct();
	pass # Replace with function body.


func load_struct():
	
	var tmpMesh = Mesh.new()
	var vertices = PoolVector3Array()
	var UVs = PoolVector2Array()
	vertices.push_back(Vector3(end_vertex.x, 0, end_vertex.z))
	vertices.push_back(Vector3(0, 0, 0))
	vertices.push_back(Vector3(0, end_vertex.y, 0))
	vertices.push_back(Vector3(end_vertex.x, end_vertex.y, end_vertex.z))
	
	vertices.push_back(Vector3(end_vertex.x, 0, end_vertex.z))
	vertices.push_back(Vector3(end_vertex.x, end_vertex.y, end_vertex.z))
	vertices.push_back(Vector3(0, end_vertex.y, 0))
	vertices.push_back(Vector3(0, 0, 0))
	
	var dist = Math.distance(0,0,end_vertex.x,end_vertex.z)*.25;
	var hei = end_vertex*.25;
	
	UVs.push_back(Vector2(dist,hei.y))
	UVs.push_back(Vector2(0,hei.y))
	UVs.push_back(Vector2(0,0))
	UVs.push_back(Vector2(dist,0))
	
	UVs.push_back(Vector2(dist,hei.y))
	UVs.push_back(Vector2(dist,0))
	UVs.push_back(Vector2(0,0))
	UVs.push_back(Vector2(0,hei.y))
	
	
	var st = SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLE_FAN)
	
	for v in vertices.size():
		st.add_uv(UVs[v])
		st.add_vertex(vertices[v])
		
	tmpMesh = st.commit();
	
	self.mesh = tmpMesh;
	
	pass

func _process(delta):
	if sky:
		material_override.update_perspective();
	pass
