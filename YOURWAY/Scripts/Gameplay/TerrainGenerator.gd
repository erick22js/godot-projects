extends Node


var TerrainNoise = OpenSimplexNoise.new();

func _init():
	TerrainNoise.seed = randi();#hash("teste");
	TerrainNoise.octaves = 4
	TerrainNoise.period = 20
	TerrainNoise.persistence = 0.8

func generateTerrain(Quad:Vector2)->Array:
	var partTerrain:Array = [];
	for xl in range(16):
		partTerrain.append([])
		for yl in range(12):
			var noise = TerrainNoise.get_noise_2d(xl+Quad.x*16, yl+Quad.y*12);
			print(str(noise))
			partTerrain[xl].append(
				0 if noise>-.2 else 
				6 if noise>-.3 else
				12
			)
	return partTerrain;

func detectTerrainPart(Quad:Vector2)->Array:
	#First, check is exist saved quad in specific coord
	var indexQuadrant = (2 if Quad.y>=-1 else 0)+(1 if Quad.x>=0 else 0);
	#$Label.text = 
	var quadX = Quad.x if Quad.x>=0 else -Quad.x+1;
	var quadY = Quad.y if Quad.y>=0 else -Quad.y+1;
	#([]).resize()
	if(Settings.GameMap[indexQuadrant].size()>quadY):
		if(Settings.GameMap[indexQuadrant][quadY]!=null):
			if(Settings.GameMap[indexQuadrant][quadY].size()>quadX):
				if(Settings.GameMap[indexQuadrant][quadY][quadX]!=null):
					return Settings.GameMap[indexQuadrant][quadY][quadX]
			else:
				Settings.GameMap[indexQuadrant][quadY].resize(quadX+1);
		else:
			Settings.GameMap[indexQuadrant][quadY] = []
			Settings.GameMap[indexQuadrant][quadY].resize(quadX+1);
	else:
		Settings.GameMap[indexQuadrant].resize(quadY+1);
		Settings.GameMap[indexQuadrant][quadY] = []
		Settings.GameMap[indexQuadrant][quadY].resize(quadX+1);
	var part = generateTerrain(Quad)
	Settings.GameMap[indexQuadrant][quadY][quadX] = part;
	return part;
