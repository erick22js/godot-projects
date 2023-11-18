extends Node


#-----------------------MATH UTILS------------------------
func angle(p1:Vector2, p2:Vector2):
	return atan2(p2.y-p1.y, p2.x-p1.x);
func distance(p1:Vector2, p2:Vector2):
	return sqrt(pow(p2.x-p1.x,2)+pow(p2.y-p1.y,2));
func radianToDegress(radian):
	return radian/PI*180;
func degressToRadian(angle):
	return angle/180*PI;

func random(end, start=0):
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var value = rng.randf_range(start, end);
	return value;

#---------------------FILE OPERATIONS----------------------
func readJsonFile(path:String):
	var file = File.new();
	file.open(path, File.READ);
	return JSON.parse(file.get_as_text()).result;

#----------------------AUDIO HANDLING-----------------------
var present_songs = 0;
