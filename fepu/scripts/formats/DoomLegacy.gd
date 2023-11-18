extends Node


func u16toInt(from:int)-> int:
	return from if from < 0x8000 else from - 0x10000

func u32toInt(from:int)-> int:
	return from if from < 0x80000000 else from - 0x100000000

func loadWadMap(file:String, map_name:String)-> Dictionary:
	var data = {"points":[], "linedefs":[], "sidedefs":[], "shapes":[], "sectors":[]}
	var wad := FileAccess.open(file, FileAccess.READ)
	
	wad.get_32() # Skips Header Name
	var lumps_count = wad.get_32()
	var lumps_seek = wad.get_32()
	
	wad.seek(lumps_seek)
	
	# Search for map index
	var lumps:Array = []
	var lump:Array = []
	var map_ind = -1
	while lumps_count > 0:
		var off = wad.get_32()
		var siz = wad.get_32()
		var nam = wad.get_buffer(8)
		if nam.get_string_from_ascii()==map_name:
			map_ind = lumps.size()
		lumps.push_back([nam, off, siz])
		lumps_count -= 1
	
	# If has NOT found, return as a empty map
	if map_ind == -1:
		return data
	
	# Retrive the points
	lump = lumps[map_ind + 4]
	wad.seek(lump[1])
	for v in range(0, lump[2], 4):
		var x:float =  u16toInt(wad.get_16())
		var y:float = u16toInt(wad.get_16())
		data["points"].push_back({ "x": x, "y": y })
		pass
	
	# Retrieve the linedefs and sidedefs
	lump = lumps[map_ind + 5]
	wad.seek(lump[1])
	for l in range(0, lump[2], 12):
		var line = {
			"id": -1,
			"p1": wad.get_16(),
			"p2": wad.get_16(),
			"_angle": u16toInt(wad.get_16()),
			"_line": wad.get_16(),
			"_side": wad.get_16(),
			"_offset": wad.get_16()
		}
		if line["_side"]==1:
			var op1 = line["p1"]
			line["p1"] = line["p2"]
			line["p2"] = op1
		var pos = wad.get_position()
		wad.seek(lumps[map_ind + 2][1] + line["_line"]*14 + 10)
		line["_front"] = wad.get_16()
		line["_back"] = wad.get_16()
		wad.seek(pos)
		data["linedefs"].push_back(line)
		
		var side = {
			"line": data["linedefs"].size()-1,
			"right": line["_side"]==0,
			"faces": [{}],
			"_sector": 0
		}
		pos = wad.get_position()
		wad.seek(lumps[map_ind + 2][1] + line["_line"]*14 + 10)
		if line["_side"]==1:
			wad.get_16()
		wad.seek(lumps[map_ind + 3][1] + wad.get_16()*30 + 28);
		side["_sector"] = wad.get_16()
		wad.seek(pos)
		data["sidedefs"].push_back(side)
		pass
	
	data["shapes"].push_back([])
	
	# Retrieve the sectors
	lump = lumps[map_ind + 6]
	wad.seek(lump[1])
	for s in range(0, lump[2], 4):
		var sector = {
			"floor_height": 0,
			"ceil_height": 0,
			"sides": [],
			"shape": 0
		}
		var seg_count = wad.get_16()
		var seg_first = wad.get_16()
		var pos = wad.get_position()
		for g in range(seg_first, seg_first+seg_count):
			sector["sides"].push_back(g)
		var si = data["sidedefs"][seg_first]["_sector"]
		wad.seek(lumps[map_ind + 8][1] + si*26);
		sector["floor_height"] = u16toInt(wad.get_16())
		sector["ceil_height"] = u16toInt(wad.get_16())
		wad.seek(pos)
		data["sectors"].push_back(sector)
	
	return data
