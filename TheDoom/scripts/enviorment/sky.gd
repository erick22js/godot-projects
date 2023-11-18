extends ShaderMaterial


func _process(delta):
	print("material")
	pass

func update_perspective():
	
	var rot = GlobalData.globalCamera.rotation;
	self.set_shader_param("rotate", Vector2(-rot.y, rot.x));
	pass
