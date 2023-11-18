extends Node2D

export (String, FILE) var main_level
export var grid_size = 16;

var map_handdler = load("res://scripts/editor/map_handdler.gd")

#CONSTANTS PRE MADE
#Elements
const vertex = "vertex";
const line = "line";
const sector = "sector";

var sel_elem_mode = "vertex";
var sel_tool_mode = "put";

var selectedElement = null;

var position_d = Vector2(0,0);

export var map_properties = {
	"vertex":[],
	"line":[],
	"sector":[]
}

func _ready():
	$toolOption.add_item("put");
	$toolOption.add_item("remove");
	$toolOption.add_item("handdle");
	
	$elementOption.add_item(vertex);
	$elementOption.add_item(line);
	$elementOption.add_item(sector);
	pass

func _process(delta):
	$Label.text = "x: "+str(position_d.x)+"   y: "+str(position_d.y);
	pass

func _input(event):
	if event is InputEventMouse:
		var coord = get_viewport().get_mouse_position()-$drawFrame.rect_position;
		position_d = coord;
	if event is InputEventMouseButton:
		if event.pressed:
			var coord = get_viewport().get_mouse_position()-$drawFrame.rect_position;
			coord = snap_coord(coord);
			touch_element(coord);
		else:
			pass
	pass

func snap_coord(vector):
	return Vector2(round(vector.x/grid_size)*grid_size, round(vector.y/grid_size)*grid_size);

func touch_element(coordinates):
	match $elementOption.get_item_text($elementOption.selected):
		vertex:
			put_vertex(coordinates);
		line:
			put_line(coordinates);
			pass
	pass


func unpick_element():
	if selectedElement!=null:
		selectedElement.selected = false;
		selectedElement = null;
	return

func put_vertex(pos):
	if !pick_vertex(pos):
		map_properties.vertex.append({"position":pos, "selected":false, "type":vertex});
		unpick_element();
	else:
		pick_vertex(pos);
	pass

func pick_vertex(pos):
	print(selectedElement);
	unpick_element();
	for i in map_properties.vertex:
		if Math.pointInRadius(i.position.x, i.position.y, 6, pos.x, pos.y):
			selectedElement = i;
			selectedElement.selected = true;
			return true;
	print(selectedElement);
	return false;


func put_line(pos):
	if selectedElement!=null:
		var v1 = selectedElement;
		if pick_vertex(pos):
			map_properties.line.append({"vertex1":v1, "vertex2":selectedElement, "selected":false, "type":line});
		pass
	else:
		pick_vertex(pos);
	pass


func _on_Button_pressed():
	var out = GlobalData.Map;
	for i in map_properties.line:
		out.walls.append({
			"point": i.vertex1.position/16,
			"size": Vector2(i.vertex2.position.x-i.vertex1.position.x, i.vertex2.position.y-i.vertex1.position.y)/16
		})
	get_tree().change_scene(main_level);
	pass # Replace with function body.


func _on_load_button_pressed():
	var json = MapHanddler.import_json($LineEdit.text);
	GlobalData.Map = MapHanddler.json_to_map(json,$LineEdit2.text);
	
	pass # Replace with function body.
