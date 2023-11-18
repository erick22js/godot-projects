extends Node

const MapChunksSize := Vector2(16, 16)
const chunkDimensions := Vector3(16, 64, 16)

func GenerateChunk(gridX:int, gridY:int)->Array:
	var blocks = []
	blocks.resize(chunkDimensions.x*chunkDimensions.y*chunkDimensions.z)
	for x in chunkDimensions.x:
		for y in chunkDimensions.y:
			for z in chunkDimensions.x:
				var block = "air";
				#if x<8 or z<8:
				if y<48:
					block = "grass";
				if y<47:
					block = "dirt";
				if y<40:
					block = "stone";
				blocks[x*chunkDimensions.y*chunkDimensions.z+y*chunkDimensions.z+z] = block
				pass
	return blocks

func GenerateMap()->Array:
	var Map := []
	Map.resize(MapChunksSize.x)
	for x in MapChunksSize.x:
		Map[x] = []
		Map[x].resize(MapChunksSize.y)
		for y in MapChunksSize.y:
			Map[x][y] = GenerateChunk(x, y)
	return Map

func block_at(x:int, y:int, z:int):
	if y<0 or x<0 or z<0 or y>chunkDimensions.y or x>=chunkDimensions.x*MapChunksSize.x or z>=chunkDimensions.z*MapChunksSize.y:
		return "air"
	print("passed "+str(y))
	var chunk = Global.GChunks[floor(x/MapChunksSize.x)][floor(z/MapChunksSize.y)]
	return chunk[x%int(MapChunksSize.x)*MapGenerator.chunkDimensions.y*MapGenerator.chunkDimensions.z+y*MapGenerator.chunkDimensions.z+z%int(MapChunksSize.y)]
