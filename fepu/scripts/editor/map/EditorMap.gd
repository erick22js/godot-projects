extends Node
class_name EditorMap


# Properties
var points:Array[EditorPoint] = []
var linedefs:Array[EditorLinedef] = []
var sectors:Array[EditorSector] = []

var selected:Array[EditorElement] = []

func _init():
	pass

#
#	Access and control methods
#
func selectElement(element:EditorElement, mode:int = 1)-> bool:
	match mode:
		-1: # SUBTRACT
			if element._selected:
				element._selected = false
				selected.remove_at(selected.find(element))
				return true
			pass
		0: # SET
			for s in selected:
				s._selected = false
			selected.clear()
			if element:
				element._selected = true
				selected.push_back(element)
			return true
		1: # ADD
			if not element._selected:
				element._selected = true
				selected.push_back(element)
				return true
			pass
		2: # TOGGLE
			if not element._selected:
				element._selected = true
				selected.push_back(element)
			else:
				element._selected = false
				selected.remove_at(selected.find(element))
			return true
	return false

func addPoint(position:Vector2)-> EditorPoint:
	var point := EditorPoint.new()
	point.pos = position
	points.push_back(point)
	return point

func searchPoint(position:Vector2, rounding:float = 5.0)-> EditorPoint:
	for p in points:
		if p.pos.distance_to(position) <= rounding:
			return p
	return null

func removePoint(point:EditorPoint)-> bool:
	var index = points.find(point)
	if index >= 0:
		var lines := searchLinedefsPoint(point)
		for l in lines:
			removeLinedef(l)
		points.remove_at(index)
		return true
	selectElement(point, -1)
	return false

func selectedPoints()-> Array[EditorPoint]:
	var points:Array[EditorPoint] = []
	for s in selected:
		if s.type == EditorElement.Type.POINT:
			points.push_back(s)
	return points

func addLinedef(p1:EditorPoint, p2:EditorPoint)-> EditorLinedef:
	var line := EditorLinedef.new()
	line.p1 = p1
	line.p2 = p2
	linedefs.push_back(line) 
	return line

func searchLinedef(position:Vector2, rounding:float = 5.0)-> EditorLinedef:
	for l in linedefs:
		if abs(l.p1.pos.distance_to(l.p2.pos) - l.p1.pos.distance_to(position) - l.p2.pos.distance_to(position)) <= rounding:
			return l
	return null

func searchLinedefsPoint(point:EditorPoint)-> Array[EditorLinedef]:
	var lines:Array[EditorLinedef] = []
	for l in linedefs:
		if l.p1 == point or l.p2 == point:
			lines.push_back(l)
	return lines

func searchLinedefPoints(p1:EditorPoint, p2:EditorPoint)-> EditorLinedef:
	for l in linedefs:
		if (l.p1 == p1 and l.p2 == p2) or (l.p1 == p2 and l.p2 == p1):
			return l
	return null

func areConnectedLinedefs(l1:EditorLinedef, l2:EditorLinedef)-> bool:
	return l1.p1 == l2.p1 or l1.p2 == l2.p2 or l1.p1 == l2.p2 or l1.p2 == l2.p1

func removeLinedef(line:EditorLinedef)-> bool:
	var index = linedefs.find(line)
	if index >= 0:
		var secs := searchSectorsLinedef(line)
		for s in secs:
			removeSector(s)
		linedefs.remove_at(index)
		return true
	selectElement(line, -1)
	return false

func selectedLines()-> Array[EditorLinedef]:
	var lines:Array[EditorLinedef] = []
	for s in selected:
		if s.type == EditorElement.Type.LINEDEF:
			lines.push_back(s)
	return lines

func addSector(first_point:EditorPoint, lines:Array[EditorLinedef])-> EditorSector:
	var sector := EditorSector.new()
	sector.lines = lines.duplicate()
	for l in lines:
		# Attaching a new Sidedef to line
		var side:EditorSidedef = EditorSidedef.new()
		l.sides.push_back(side)
		side.line = l
		side.sector = sector
		
		# Attaching a new Facedef to side
		var face:EditorFacedef = EditorFacedef.new()
		side.faces.push_back(face)
		face.side = side
		sector.sides.push_back(side)
		
		if sector.path.size()==0:
			sector.path.append(first_point)
			if l.p2 == first_point:
				sector.path.append(l.p1)
				side.right = false
			else:
				sector.path.append(l.p2)
				side.right = true
		else:
			if sector.path.back() == l.p1 and sector.path.front() != l.p2:
				sector.path.append(l.p2)
				side.right = true
			elif sector.path.back() == l.p2 and sector.path.front() != l.p1:
				sector.path.append(l.p1)
				side.right = false
	sectors.push_back(sector)
	return sector

func searchSectorsLinedef(line:EditorLinedef)-> Array[EditorSector]:
	var secs:Array[EditorSector] = []
	for s in sectors:
		if s.lines.find(line) != -1:
			secs.push_back(s)
	return secs

func removeSector(sector:EditorSector)-> bool:
	var index = sectors.find(sector)
	if index >= 0:
		# Removing sidedefs attach from lines
		for s in sector.sides:
			s.line.sides.remove_at(s.line.sides.find(s))
		sectors.remove_at(index)
		return true
	selectElement(sector, -1)
	return false
