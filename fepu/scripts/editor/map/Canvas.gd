extends Node2D


# Properties
var proj_map:EditorMap = null

var cam_x:float = 0
var cam_y:float = 0
var cam_zoom:float = 1

var display_width:float = 0
var display_height:float = 0

var grid:float = 32

# Draw Properties
var state:Transform2D
var states:Array[Transform2D] = []
var state_i:int = 0

func _ready():
	states.resize(32)
	pass # Replace with function body.

func _process(delta):
	#print(cam_zoom, " => ", (log(cam_zoom)/log(2)), " => ", )
	#grid = 32.0 / round(cam_zoom)
	#print(grid)
	queue_redraw()
	pass

func _draw():
	#
	#	Background Rendering
	#
	push()
	var view_w:float = display_width
	var view_h:float = display_height
	var half_w:float = view_w/2
	var half_h:float = view_h/2
	var inv_zoom:float = 1/cam_zoom
	
	stateTranslate(Vector2(-cam_x * cam_zoom, -cam_y * cam_zoom))
	stateTranslate(Vector2(half_w, half_h))
	
	# Drawing the grid
	var g_cam_x:float = cam_x * cam_zoom
	var g_cam_y:float = cam_y * cam_zoom
	var g_half_w:float = half_w# / cam_zoom
	var g_half_h:float = half_h# / cam_zoom
	var g_size:float = grid * cam_zoom
	for gx in range((g_cam_x-g_half_w)/g_size - 1, (g_cam_x+g_half_w)/g_size + 2):
		draw_line(Vector2(gx*g_size, -half_h + g_cam_y), Vector2(gx*g_size, half_h + g_cam_y), Color.DARK_GRAY, -1)
		pass
	for gy in range((g_cam_y-g_half_h)/g_size - 1, (g_cam_y+g_half_h)/g_size + 2):
		draw_line(Vector2(-half_w + g_cam_x, gy*g_size), Vector2(half_w + g_cam_x, gy*g_size), Color.DARK_GRAY, -1)
		pass
	g_size *= 4
	for gx in range((g_cam_x-g_half_w)/g_size - 1, (g_cam_x+g_half_w)/g_size + 2):
		draw_line(Vector2(gx*g_size, -half_h + g_cam_y), Vector2(gx*g_size, half_h + g_cam_y), Color.WHITE, -1)
		pass
	for gy in range((g_cam_y-g_half_h)/g_size - 1, (g_cam_y+g_half_h)/g_size + 2):
		draw_line(Vector2(-half_w + g_cam_x, gy*g_size), Vector2(half_w + g_cam_x, gy*g_size), Color.WHITE, -1)
		pass
	pop()
	
	#
	#	Stage Rendering
	#
	push()
	
	stateTransform(Vector2(-cam_x, -cam_y), cam_zoom)
	stateTranslate(Vector2(half_w, half_h))
	
	var region_size := 32.0
	var viewport := Rect2(cam_x - half_w*inv_zoom, cam_y - half_h*inv_zoom, view_w*inv_zoom, view_h*inv_zoom)
	viewport.position = (viewport.position/region_size).floor() * region_size
	viewport.size = (viewport.size/region_size + Vector2(1, 1)).ceil() * region_size
	
	# Render the sectors
	for s in proj_map.sectors:
		var inside := false
		for p in s.path:
			if viewport.has_point(p.pos):
				inside = true
				break
		if inside:
			var points = PackedVector2Array()
			var color = PackedColorArray()
			for p in s.path:
				points.push_back(p.pos)
				color.push_back(Color(0.5, 0.5, 0.5, 0.5))
			draw_polygon(points, color)
	
	# Render the linedefs
	var ls := proj_map.selectedLines()
	for l in proj_map.linedefs:
		if viewport.has_point(l.p1.pos) or viewport.has_point(l.p2.pos):
			draw_line(l.p1.pos, l.p2.pos, Color.BLACK if not l.isSelected() else Color(1, 0, 0), 10.0*inv_zoom)
			draw_line(l.p1.pos, l.p2.pos, Color.BLACK if l.sides.size()==0 else Color.WHITE, 4.0*inv_zoom)
	
	# Render the points
	var ps := proj_map.selectedPoints()
	for p in proj_map.points:
		if viewport.has_point(p.pos):
			draw_circle(p.pos, 12*inv_zoom, Color.BLACK if not p.isSelected() else Color(1, 0, 0))
			draw_circle(p.pos, 8*inv_zoom, Color.WHITE)
	
	pop()
	
	#
	#	UI Rendering
	#
	#draw_rect(Rect2(half_w-8, half_h-8, 16, 16), Color.WHITE, false, 2.0)
	
	pass

#
#	Graphics Manipulation
#

func stateTransform(tr:Vector2, zoom:float):
	state = state.translated(tr)
	state = state.scaled(Vector2(zoom, zoom))
	draw_set_transform_matrix(state)
	pass

func stateTranslate(vec:Vector2):
	state = state.translated(vec)
	draw_set_transform_matrix(state)
	pass

func push():
	states[state_i] = state
	state_i += 1
	pass

func pop():
	state_i -= 1
	state = states[state_i]
	draw_set_transform_matrix(state)
	pass
