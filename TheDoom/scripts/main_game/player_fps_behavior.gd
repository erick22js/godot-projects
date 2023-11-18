extends Spatial

export var speed = .3;

func _ready():
	$head/Node2D/MobileControl.visible = true;
	GlobalData.globalCamera = $head;
	pass # Replace with function body.


func _process(delta):
	$head.rotation += Vector3(InputsGame.y*-.015, InputsGame.x*-.02, 0);
	$head.rotation.x = 0;#-1.5 if $head.rotation.x<-1.5 else (1.5 if $head.rotation.x > 1.5 else $head.rotation.x);
	
	self.translation.y = SceneMath.get_sector_by_point(self.translation.x, self.translation.z).floorY;
	
	#moviment
	var x = 0;
	x += (1 if InputsGame.key_pressed(KEY_W) else 0)-(1 if InputsGame.key_pressed(KEY_S) else 0);
	var z = 0;
	z += (1 if InputsGame.key_pressed(KEY_A) else 0)-(1 if InputsGame.key_pressed(KEY_D) else 0);
	var angMov = atan2(z, x);
	var spdMov = 1 if InputsGame.key_pressed(KEY_W) or InputsGame.key_pressed(KEY_S) or InputsGame.key_pressed(KEY_A) or InputsGame.key_pressed(KEY_D) else 0;
	
	if !InputsGame.use_mouse:
		angMov = atan2(
			$head/Node2D/MobileControl/Polygon2D2.position.x-$head/Node2D/MobileControl/Polygon2D.position.x,
			$head/Node2D/MobileControl/Polygon2D2.position.y-$head/Node2D/MobileControl/Polygon2D.position.y
			)-3.14;
		spdMov = Math.distance(
			$head/Node2D/MobileControl/Polygon2D.position.x, $head/Node2D/MobileControl/Polygon2D.position.y,
			$head/Node2D/MobileControl/Polygon2D2.position.x, $head/Node2D/MobileControl/Polygon2D2.position.y
		)*.05
	
	self.translation.x -= sin($head.rotation.y+angMov)*spdMov*speed;
	self.translation.z -= cos($head.rotation.y+angMov)*spdMov*speed;
	
	if InputsGame.mapTouches.has(0):
		if InputsGame.mapTouches[0].pressed:
			$head/Node2D/MobileControl/Polygon2D2.position = InputsGame.mapTouches[0].position;
		else:
			$head/Node2D/MobileControl/Polygon2D2.position = $head/Node2D/MobileControl/Polygon2D.position;
	
	pass
