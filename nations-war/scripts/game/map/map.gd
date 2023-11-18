extends TileMap


# Properties
var width:int = 128
var height:int = 128
var areas:Array[Array] = []

# Called when the node enters the scene tree for the first time.
func _ready():
	var noise := FastNoiseLite.new()
	noise.seed = randi()
	
	# Generating a random map
	for h in height:
		var line:Array[Area] = []
		for w in width:
			var area:Area = Area.new()
			area.is_sea = noise.get_noise_2d(w, h) < 0.15
			line.push_back(area)
		areas.push_back(line)
	for nat in Global.nations:
		var confirm = 2
		while confirm>0:
			var area:Area = areas[randi()%width][randi()%height]
			if not area.is_sea:
				area.nation = nat
				confirm -= 1
	
	for y in height:
		for x in width:
			redrawTile(x, y)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

#
#	Internal Util Methods
#

#
#	Control Methods
#
func redrawTile(x:int, y:int):
	var m_area:Area = areas[y][x]
	var mask_x:int = 0
	var mask_y:int = 0
	if x > 0:
		var d_area:Area = areas[y][x-1]
		mask_y |= 1 if d_area.nation!=m_area.nation or d_area.is_sea!=m_area.is_sea else 0
		
		if y > 0:
			var c_area:Area = areas[y-1][x-1]
			mask_x |= 2 if c_area.nation!=m_area.nation or c_area.is_sea!=m_area.is_sea else 0
			pass
		if y < height-1:
			var c_area:Area = areas[y+1][x-1]
			mask_x |= 8 if c_area.nation!=m_area.nation or c_area.is_sea!=m_area.is_sea else 0
			pass
		pass
	if y > 0:
		var d_area:Area = areas[y-1][x]
		mask_y |= 4 if d_area.nation!=m_area.nation or d_area.is_sea!=m_area.is_sea else 0
		pass
	if x < width-1:
		var d_area:Area = areas[y][x+1]
		mask_y |= 2 if d_area.nation!=m_area.nation or d_area.is_sea!=m_area.is_sea else 0
		if y > 0:
			var c_area:Area = areas[y-1][x+1]
			mask_x |= 1 if c_area.nation!=m_area.nation or c_area.is_sea!=m_area.is_sea else 0
			pass
		if y < height-1:
			var c_area:Area = areas[y+1][x+1]
			mask_x |= 4 if c_area.nation!=m_area.nation or c_area.is_sea!=m_area.is_sea else 0
			pass
		pass
	if y < height-1:
		var d_area:Area = areas[y+1][x]
		mask_y |= 8 if d_area.nation!=m_area.nation or d_area.is_sea!=m_area.is_sea else 0
		pass
	if m_area.is_sea:
		mask_x = 0
		mask_y = 0
	var skin = Vector2i(0, 0) if m_area.nation==null else Vector2i(m_area.nation.skin, 4)
	skin = Vector2i(2, 0) if m_area.is_sea else skin
	set_cell(1, Vector2i(x, y), 1, skin)
	set_cell(2, Vector2i(x, y), 0, Vector2i(mask_x, mask_y))
	pass
