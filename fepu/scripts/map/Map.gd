extends Node
class_name Map


# Properties
var points:Array[Vector2] = []
var linedefs:Array[Linedef] = []
var sidedefs:Array[Sidedef] = []
var subsectors:Array[Subsector] = []
var sectors:Array[Sector] = []

func _init(desc):
	# Creating the whole structure
	# Decode points
	for p in desc["points"]:
		points.push_back(Vector2(p["x"], p["y"]))
	
	# Decode linedefs
	for l in desc["linedefs"]:
		var line:Linedef = Linedef.new()
		line.id = l["id"]
		line.p1 = points[l["p1"]]
		line.p2 = points[l["p2"]]
		linedefs.push_back(line)
	
	# Decode sidedefs
	for s in desc["sidedefs"]:
		var side:Sidedef = Sidedef.new()
		side.line = linedefs[s["line"]]
		side.right = s["right"]
		for f in s["faces"]:
			var face:Facedef = Facedef.new()
			face.hidden = false if !f.has("hidden") else f["hidden"]
			face.side = side
			side.faces.push_back(face)
		sidedefs.push_back(side)
	
	# Decode sectors
	for s in desc["subsectors"]:
		var ssector:Subsector = Subsector.new()
		for i in s["sides"]:
			sidedefs[i].ssector = ssector
			ssector.sides.push_back(sidedefs[i])
		var shape = desc["shapes"][s["shape"]]
		for h in shape:
			ssector.shape.push_back(points[h])
		subsectors.push_back(ssector)
	
	# Decode sectors
	for s in desc["sectors"]:
		var sector:Sector = Sector.new()
		sector.floor_height = s["floor_height"]
		sector.ceil_height = s["ceil_height"]
		for i in s["subsectors"]:
			subsectors[i].sector = sector
			sector.ssectors.push_back(subsectors[i])
		sectors.push_back(sector)
	
	# Assigning left references
	# Solve Sidedefs
	for si in desc["sidedefs"].size():
		for fi in desc["sidedefs"][si]["faces"].size():
			var f = desc["sidedefs"][si]["faces"][fi]
			if f.has("portal"):
				sidedefs[si].faces[fi].portal = subsectors[f["portal"]]
	pass
