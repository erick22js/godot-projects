extends ColorRect


# Properties
var proj_map:EditorMap = null

var target_x:float = 0
var target_y:float = 0
var target_zoom:float = 1

var _acu_move:Vector2 = Vector2()

enum Mode{
	NONE = 0,
	
	POINT = 0x001,
	LINEDEF = 0x002,
	SECTOR = 0x005,
	
	ADD = 0x010,
	REMOVE = 0x020,
	MOVE = 0x080,
	ROTATE = 0x090,
	
	_OBJ = 0x00F,
	_ACTION = 0x0F0,
	_WAY = 0xF00,
}
var mode:Mode = (Mode.POINT | Mode.ADD) as Mode
var first_point:EditorPoint = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Canvas.display_width = get_rect().size.x
	$Canvas.display_height = get_rect().size.y
	
	$ModeText.text = ""
	match (mode&Mode._ACTION):
		Mode.ADD: $ModeText.text = "Create"; pass
		Mode.REMOVE: $ModeText.text = "Remove"; pass
		Mode.MOVE: $ModeText.text = "Move"; pass
		Mode.ROTATE: $ModeText.text = "Rotate"; pass
	match (mode&Mode._OBJ):
		Mode.POINT: $ModeText.text += " Point"; pass
		Mode.LINEDEF: $ModeText.text += " Linedef"; pass
		Mode.SECTOR: $ModeText.text += " Sector"; pass
	
	var smooth:float = clamp(0.4 * (delta*30), 0, 1)
	$Canvas.cam_x += (target_x-$Canvas.cam_x)* smooth
	$Canvas.cam_y += (target_y-$Canvas.cam_y)* smooth
	$Canvas.cam_zoom += (target_zoom-$Canvas.cam_zoom)* smooth
	
	var z_log2 = -floor((log($Canvas.cam_zoom)/log(2)) - 4)
	#z_log2 = floor(z_log2/2)*2
	$Canvas.grid = pow(2, z_log2)
	pass

var mouse_in:bool = false
func _input(event):
	if event is InputEventMouseMotion and mouse_in:
		zoomTo(1, event.position)
		if event.button_mask&MOUSE_BUTTON_LEFT:
			doAction(MOUSE_BUTTON_LEFT, true, event.position, event.relative)
		pass
	if event is InputEventMouseButton and mouse_in:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			if _tog:
				zoomTo(1.2, event.position)
			_tog = not _tog
			pass
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			if _tog:
				zoomTo(1.0 / (1.2), event.position)
			_tog = not _tog
			pass
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
			doAction(MOUSE_BUTTON_LEFT, false, event.position, Vector2())
		#if event.button_index == MOUSE_BUTTON_RIGHT:
		#	doAction(MOUSE_BUTTON_LEFT, event.position, Vector2())
	if event is InputEventKey:
		match event.keycode:
			KEY_C:
				mode = mode&(~Mode._ACTION) | Mode.ADD
				proj_map.selectElement(null, 0)
				pass
			KEY_R: mode = mode&(~Mode._ACTION) | Mode.REMOVE; pass
			KEY_M: mode = mode&(~Mode._ACTION) | Mode.MOVE; pass
			KEY_G: mode = mode&(~Mode._ACTION) | Mode.ROTATE; pass
			
			KEY_P:
				mode = mode&(~Mode._OBJ) | Mode.POINT
				if mode&Mode._ACTION == Mode.ADD:
					proj_map.selectElement(null, 0)
				pass
			KEY_L:
				mode = mode&(~Mode._OBJ) | Mode.LINEDEF
				if mode&Mode._ACTION == Mode.ADD:
					proj_map.selectElement(null, 0)
				pass
			KEY_S:
				mode = mode&(~Mode._OBJ) | Mode.SECTOR
				if mode&Mode._ACTION == Mode.ADD:
					proj_map.selectElement(null, 0)
				pass
			
			KEY_ESCAPE: proj_map.selectElement(null, 0); pass
	pass

func _onMouseEntered():
	mouse_in = true
	pass # Replace with function body.

func _onMouseExited():
	mouse_in = false
	pass # Replace with function body.

#
#	Utilities Functions
#

func spaceToScreen(space:Vector2)-> Vector2:
	space -= Vector2(target_x, target_y)
	space *= target_zoom
	var v := space + get_rect().size/2 + position
	return v

func screenToSpace(screen:Vector2)-> Vector2:
	var v := screen - position
	var p := v - get_rect().size/2
	p = p / target_zoom + Vector2(target_x, target_y)
	return p

func snapGrid(space:Vector2)-> Vector2:
	return (space/$Canvas.grid).round()*$Canvas.grid

#
#	Working Functions
#

var _tog = false
func zoomTo(scl, mouse:Vector2):
	var v_x = mouse.x - position.x
	var v_y = mouse.y - position.y
	var p_x = v_x - get_rect().size.x/2
	var p_y = v_y - get_rect().size.y/2
	
	var q1_x = p_x / target_zoom
	var q1_y = p_y / target_zoom
	var q2_x = q1_x / scl
	var q2_y = q1_y / scl
	
	if scl < 1.0 and target_zoom < 1.0/128.0:
		return
	
	target_x += q1_x-q2_x
	target_y += q1_y-q2_y
	if scl > 1.0 and target_zoom > 128.0:
		return
	target_zoom *= scl
	pass

func doAction(btn, drag:bool, mouse:Vector2, relative:Vector2):
	match (mode&Mode._ACTION):
		#
		#	ADD ACTION
		Mode.ADD:
			var space := snapGrid(screenToSpace(mouse))
			match (mode&Mode._OBJ):
				Mode.POINT:
					createPoint(space)
					pass
				Mode.LINEDEF:
					var point := createAndSelectPoint(space)
					var line := createLinedefWithSelectedsPoints()
					if line:
						selectFirstPoint(-1)
					pass
				Mode.SECTOR:
					var point := createAndSelectPoint(space)
					var line := createLinedefWithSelectedsPoints()
					if line:
						selectFirstPoint(-1)
						proj_map.selectElement(line, 1)
					else:
						first_point = point
					var ls := proj_map.selectedLines()
					if ls.size() >= 3 and proj_map.areConnectedLinedefs(ls.front(), ls.back()):
						proj_map.addSector(point, ls)
						proj_map.selectElement(null, 0)
					pass
		#
		#	REMOVE ACTION
		Mode.REMOVE:
			var space := snapGrid(screenToSpace(mouse))
			match (mode&Mode._OBJ):
				Mode.POINT:
					var point := proj_map.searchPoint(space, 5.0/target_zoom)
					if point:
						proj_map.removePoint(point)
					pass
				Mode.LINEDEF:
					var line := proj_map.searchLinedef(space, 5.0/target_zoom)
					if line:
						proj_map.removeLinedef(line)
					pass
		#
		#	MOVE ACTION
		Mode.MOVE:
			var space := screenToSpace(mouse)
			if drag:
				# Extract each element until point state
				var points:Array[EditorPoint] = []
				var ps := proj_map.selectedPoints()
				var ls := proj_map.selectedLines()
				for p in ps:
					points.push_back(p)
				for l in ls:
					if points.find(l.p1)==-1:
						points.push_back(l.p1)
					if points.find(l.p2)==-1:
						points.push_back(l.p2)
				
				# Translates each point
				_acu_move += relative/target_zoom
				var int_move:Vector2 = snapGrid(_acu_move)
				_acu_move -= snapGrid(_acu_move)
				for p in points:
					p.pos += int_move
			else:
				match (mode&Mode._OBJ):
					Mode.POINT:
						var point := proj_map.searchPoint(space, 5.0/target_zoom)
						if point:
							proj_map.selectElement(point, 0)
						pass
					Mode.LINEDEF:
						var line := proj_map.searchLinedef(space, 5.0/target_zoom)
						if line:
							proj_map.selectElement(line, 0)
						pass
		#
		#	DEFAULT ACTION
		_:
			pass
	pass

func selectFirstPoint(mode:int = 1):
	var ps := proj_map.selectedPoints()
	if ps.size() > 0:
		proj_map.selectElement(ps[0], mode)

func selectFirstLinedef(mode:int = 1):
	var ls := proj_map.selectedLines()
	if ls.size() > 0:
		proj_map.selectElement(ls[0], mode)

func createPoint(pos:Vector2)-> EditorPoint:
	var point := proj_map.searchPoint(pos, 5.0/target_zoom)
	if not point:
		proj_map.addPoint(pos)
	return point

func createAndSelectPoint(pos:Vector2)-> EditorPoint:
	var point := proj_map.searchPoint(pos, 5.0/target_zoom)
	if point:
		proj_map.selectElement(point, 1)
	else:
		point = proj_map.addPoint(pos)
		proj_map.selectElement(point, 1)
	return point

func createLinedefWithSelectedsPoints()-> EditorLinedef:
	var ps := proj_map.selectedPoints()
	var line:EditorLinedef = null
	if ps.size() == 2:
		line = proj_map.searchLinedefPoints(ps[0], ps[1])
		if line == null:
			line = proj_map.addLinedef(ps[0], ps[1])
	return line
