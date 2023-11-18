extends Node

var Map = {
	"walls":[]
}

var globalCamera = {};

var Textures = {};

func scan_directory(src):
	var dir = Directory.new();
	dir.open(src);
	dir.list_dir_begin();
	while true:
		var f = dir.get_next();
		if f=="":
			break;
		if isFile(src+"/"+f):
			if isPNG(f):
				var name = f.get_basename();
				Textures[name] = load(str(src+"/"+f));
				#print(f);
	pass
	pass

func isFile(src):
	var file = File.new();
	file.open(src, File.READ);
	var e = file.file_exists(src);
	file.close();
	return e;
func existDic(src):
	var file = Directory.new();
	file.open(src);
	var e = file.dir_exists(src);
	return e;
func isPNG(src:String):
	var ext = src.get_extension();
	if ext=="png":
		return true;
	return false;

func _init():
	scan_directory("res://textures/castle");
	scan_directory("res://textures/hell");
	scan_directory("res://textures/liquid");
	scan_directory("res://textures/space");
	Textures["blank"] = null;
	#Load textures
	

