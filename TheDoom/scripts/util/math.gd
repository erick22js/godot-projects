extends Node



func distance(x1, y1, x2, y2):
	return sqrt((x2-x1)*(x2-x1)+(y2-y1)*(y2-y1));

func pointInRadius(x, y, r, px, py):
	return distance(x, y, px, py) <= r;

func pointInPolygon(vertices, px, py):
	var collision = false;
	var next = 0;
	for current in range(vertices.size()):
		next = current + 1;
		if (next == vertices.size()):
			next = 0;
		var vc = vertices[current];
		var vn = vertices[next];
		if (((vc.y >= py && vn.y < py) || (vc.y < py && vn.y >= py)) &&
			(px < (vn.x - vc.x) * (py - vc.y+.0) / (vn.y - vc.y+.0) + vc.x)):
			collision = !collision;
	return collision;
