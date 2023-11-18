extends Node

var chunk_obj = preload("res://Objects/Chunk.tscn")

export (NodePath)var pov_render = null
var radius_render = 5

var threadChunk = Thread.new()
var allowChunkUpdate = false

func _ready():
	pov_render = get_node(pov_render)
	Global.GChunks = MapGenerator.GenerateMap()
	for x in range(-radius_render, radius_render):
		for y in range(-radius_render, radius_render):
			var chunk = chunk_obj.instance();
			#chunk.translate(Vector3(x*16, 0, y*16))
			chunk.chunk_index = Vector2(x, y)
			chunk.set_chunk_position(Vector2(x, y))
			add_child(chunk)
	#thread.start(self, "_thread_process", null)
	threadChunk.start(self, "_thread_chunkUpdate", null)

func update_chunks():
	allowChunkUpdate = true;
	pass

func _thread_chunkUpdate(_userdata):
	while true:
		for c in get_children():
			c.set_chunk_position(c.chunk_index+pov_render.chunk)
			c.updateChunk()
			print("Chunk updated!")
		#allowChunkUpdate = false
