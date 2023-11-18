extends MeshInstance


var vertex = [];
var meshs = [];

var sector = null;
var material = load("res://shaders/floor.tres");
var material_sky = load("res://shaders/background_sky.tres");

var upper = null;
var sec_index = null;

var sky = false;

func _ready():
	if(sky):
		self.material_override = material_sky.duplicate(false);
	else:
		self.material_override = material.duplicate(false);
		var sector = GlobalData.Map.sector[sec_index];
		self.material_override.set_shader_param("texture_scale",Vector2(2,2));
		self.material_override.set_shader_param("m_color", Color(sector.color[0],sector.color[1],sector.color[2],sector.color[3]));
		self.material_override.set_shader_param("fog_color",Color(sector.colorFog[0],sector.colorFog[1],sector.colorFog[2],sector.colorFog[3]))
		self.material_override.set_shader_param("fog_distance",sector.distanceFogMax/64.0)
		self.material_override.set_shader_param("tex",GlobalData.Textures[(sector.textureD if upper else sector.textureU)]);
	load_struct();
	pass # Replace with function body.


func load_struct():
	for i in meshs:
		def_triangle(i);
	pass

func def_triangle(triangle):
	
	var triangle_instance = MeshInstance.new();
	var tmpMesh = Mesh.new()
	var vertices = PoolVector3Array()
	var UVs = PoolVector2Array()
	
	for i in triangle:
		vertices.push_back(Vector3(i.x, 0, i.y))
	for i in triangle:
		vertices.insert(0, Vector3(i.x, 0, i.y))
	
	
		
	for i in triangle:
		UVs.push_back(Vector2(i.x*.25, i.y*.25));
	for i in triangle:
		UVs.insert(0, Vector2(i.x*.25, i.y*.25));
	
	var st = SurfaceTool.new()
	PrimitiveMesh.PRIMITIVE_TRIANGLES
	st.begin(PrimitiveMesh.PRIMITIVE_TRIANGLE_FAN)
	
	for v in vertices.size():
		st.add_uv(UVs[v])
		st.add_vertex(vertices[v])
	tmpMesh = st.commit();
	
	triangle_instance.mesh = tmpMesh;
	triangle_instance.material_override = self.material_override;
	add_child(triangle_instance);
	
	
	pass

func _process(delta):
	if sky:
		material_override.update_perspective();
	pass
