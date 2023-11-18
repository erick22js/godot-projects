extends Node


var wall_class = preload("res://objects/wall.tscn");
var floor_class = preload("res://objects/floor.tscn");

func gen_wall(wall, sectors_pack:Array, index):
	if(!wall.sidedef):
		var wallf = wall_class.instance();
		wallf.sector = wall.sector[0];
		wallf.sec_index = index;
		wallf.handle_heig = "middler";
		wallf.wall = wall;
		wallf.sky = sectors_pack[wallf.sector].skyMiddle;
		wallf.translate(Vector3(wall.v1.x, sectors_pack[wall.sector[0]].floorY, wall.v1.y));
		wallf.end_vertex = Vector3(
			wall.v2.x-wall.v1.x,
			sectors_pack[wall.sector[0]].ceilY-sectors_pack[wall.sector[0]].floorY,
			wall.v2.y-wall.v1.y
		)
		return wallf;
	else:
		var s1 = sectors_pack[wall.sector[0]];
		var s2 = sectors_pack[wall.sector[1]];
		var minfloorsector = wall.sector[0] if s1.floorY<s2.floorY else wall.sector[1];
		var maxceilsector = wall.sector[0] if s1.ceilY>s2.ceilY else wall.sector[1];
		var abvMin = s1.floorY if s1.floorY <= s2.floorY else s2.floorY;
		var abvMax = s1.floorY if s1.floorY >= s2.floorY else s2.floorY;
		var ovrMin = s1.ceilY if s1.ceilY <= s2.ceilY else s2.ceilY;
		var ovrMax = s1.ceilY if s1.ceilY >= s2.ceilY else s2.ceilY;
		
		var wallfd = wall_class.instance();
		wallfd.sector = minfloorsector;
		wallfd.sec_index = minfloorsector;
		wallfd.handle_heig = "downer";
		wallfd.wall = wall;
		wallfd.sky = sectors_pack[wallfd.sector].skyDown;
		wallfd.translate(Vector3(wall.v1.x, abvMin, wall.v1.y));
		wallfd.end_vertex = Vector3(
			wall.v2.x-wall.v1.x,
			abvMax-abvMin,
			wall.v2.y-wall.v1.y
		)
		
		var wallfu = wall_class.instance();
		wallfu.sector = maxceilsector;
		wallfu.sec_index = maxceilsector;
		wallfu.handle_heig = "upper";
		wallfu.wall = wall;
		wallfu.sky = sectors_pack[wallfu.sector].skyTop;
		wallfu.translate(Vector3(wall.v1.x, ovrMin, wall.v1.y));
		wallfu.end_vertex = Vector3(
			wall.v2.x-wall.v1.x,
			ovrMax-ovrMin,
			wall.v2.y-wall.v1.y
		)
		
		
		return [wallfd, wallfu];
		
		pass
	pass

func gen_floor(upper:bool, sector, index):
	if upper:
		var floorf = floor_class.instance();
		floorf.sector = index;
		floorf.sec_index = index;
		floorf.sky = sector.skyTop;
		floorf.translate(Vector3(0, sector.ceilY, 0));
		floorf.meshs = GlobalData.Map.meshs[index];
		return floorf;
	else:
		var floorf = floor_class.instance();
		floorf.sector = index;
		floorf.sec_index = index;
		floorf.sky = sector.skyDown;
		floorf.translate(Vector3(0, sector.floorY, 0));
		floorf.meshs = GlobalData.Map.meshs[index];
		return floorf;
	pass
