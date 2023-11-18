extends Spatial



func _ready():
	pass # Replace with function body.

func _input(event):
	pass

func _process(delta):
	
	var rvel = Vector3(0, 0, 0)
	if(Ginput.getKey(KEY_W)):
		rvel.z -= 1
	if(Ginput.getKey(KEY_S)):
		rvel.z += 1
	if(Ginput.getKey(KEY_A)):
		rvel.x -= 1
	if(Ginput.getKey(KEY_D)):
		rvel.x += 1
	$Body.rotate_y(-Ginput.mouse["motion"].x/128)
	$Body/Head.rotate_x(-Ginput.mouse["motion"].y/128)
	rvel = rvel.rotated(Vector3(0, 1, 0), $Body.rotation.y)
	
	$Body.phy_torque = rvel
	
	pass
