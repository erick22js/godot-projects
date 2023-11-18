extends CanvasModulate

func _ready():
	pass # Replace with function body.

func _process(delta):
	update();
	pass

func _draw():
	var map = get_parent().get_parent().map_properties;
	draw_grid();
	for l in map.line:
		draw_line_map(l);
	for v in map.vertex:
		draw_vertex_map(v);
	pass

func draw_grid():
	for x in range(0, get_parent().rect_size.x, get_parent().get_parent().grid_size):
		draw_line(Vector2(x, 0), Vector2(x, get_parent().rect_size.y), Color(0,0,0,1),1.5);
	for y in range(0, get_parent().rect_size.y, get_parent().get_parent().grid_size):
		draw_line(Vector2(0, y), Vector2(get_parent().rect_size.x, y), Color(0,0,0,1),1.5);
	pass

func draw_vertex_map(v):
	draw_circle(v.position, 5, Color.black);
	draw_circle(v.position, 3.5, Color.white if !v.selected else Color.orange);
	pass

func draw_line_map(line):
	draw_line(line.vertex1.position, line.vertex2.position, Color.black, 3);
	pass
