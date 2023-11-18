extends Spatial

var player_instance = preload("res://objects/player_fps.tscn");


func _ready():
	if(InputsGame.use_mouse):
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN);
	InputsGame.executing_mouse_look = true; 
	
	#Generate Map
	for i in GlobalData.Map.line:
		if i.sector.size() == 0:
			continue;
		var element = GenerateObjects.gen_wall(i, GlobalData.Map.sector, i.sector[0]);
		if (typeof(element)==TYPE_ARRAY):
			insert_wall(element[0], true);
			insert_wall(element[1], false);
		else:
			insert_wall(element);
	for i in range(GlobalData.Map.sector.size()):
		insert_floor(GenerateObjects.gen_floor(false, GlobalData.Map.sector[i], i), false);
		insert_floor(GenerateObjects.gen_floor(true, GlobalData.Map.sector[i], i), true);
	print(GlobalData.Map.sector[0]);
	#Instance things
	var player = player_instance.instance();
	player.name = "Marine";
	#player.material_override.set_shader_param("m_color",Color(0,1,0,1));
	$things.add_child(player);
	
	pass # Replace with function body.

func insert_wall(wall, inferior=false):
	var ss = wall.sector;
	var sector = GlobalData.Map.sector[ss];
	$structs.add_child(wall);
	pass
func insert_floor(floor_, upper):
	var ss = floor_.sector;
	floor_.upper = upper;
	var sector = GlobalData.Map.sector[ss];
	$structs.add_child(floor_);
	pass

func _process(delta):
	
	pass


