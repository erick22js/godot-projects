extends Spatial;

#The card appearances
onready var backMesh:MeshInstance = $Mesh/BackMesh;
onready var frontMesh:MeshInstance = $Mesh/FrontMesh;

#The card properties
var card_type:int = 0;

#The card animations properties
var follow_t:Vector3 = Vector3(0, 0, 0);
var follow_tspeed:float = 0;
var follow_r:Vector3 = Vector3(0, 0, 0);
var follow_rspeed:float = 0;

#
#	MODULE FUNCTIONS
#

func _SetFace(x:int, y:int):
	var front_mt:ShaderMaterial = frontMesh.material;
	front_mt.set_shader_param("face", Vector2(x, y));
	pass

func _UpdateAnim():
	self.translation += (follow_t-self.translation)*follow_tspeed;
	self.rotation += (follow_r-self.rotation)*follow_r;
	pass



#
#	MAIN FUNCTIONS
#

func _ready():
	pass

func _process(delta):
	_UpdateAnim();
	pass
