extends Node

func get_sector_by_point(x, y):
	for i in GlobalData.Map.sector:
		if(Math.pointInPolygon(i.vertex, x, y)):
			return i;
	
	return {"ceilY":4.5, "floorY":0};
