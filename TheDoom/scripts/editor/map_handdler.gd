extends Node











#Export, Import and load map methods

func import_json(src):
	var file = File.new();
	file.open(src, File.READ);
	var text = file.get_as_text();
	var data = JSON.parse(text).result;
	print("import");
	return data;

func json_to_map(json, map_name):
	var map = json["maps"][map_name];
	var vertices = JSON.parse(map).result["vertex"];
	var lines = JSON.parse(map).result["lines"];
	var meshs = JSON.parse(map).result["meshs"];
	
	for i in lines:
		i.v1.x /= 16.0
		i.v2.x /= 16.0
		i.v1.y /= 16.0
		i.v2.y /= 16.0
	var sectors = JSON.parse(map).result["sectors"];
	for i in sectors:
		for v in i.vertex:
			v.x /= 16.0
			v.y /= 16.0
		i.ceilY /= 16.0
		i.floorY /= 16.0
	for m in meshs:
		for s in m:
			for v in s:
				v.x /= 16.0
				v.y /= 16.0
	
	return {"vertex":vertices, "line":lines, "sector":sectors, "meshs":meshs};


