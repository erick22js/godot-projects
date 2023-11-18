extends KinematicBody

tool

###############################################################
#	PROPERTIES
###############################################################

#	Shape Bound properties
var _bound_shape:CapsuleShape;
export var bound_radius:float = 1.0;
export var bound_height:float = 1.0;

#	Physic properties
export var _gravity:float = 1
export var _mass:float = 1
export var _motion:Vector3 = Vector3(0.0, 0.0, 0.0);

###############################################################
#	BACK FUNCTIONS
###############################################################

#	Setup the colision bound
func _setup_col_bound():
	#Setup colision bound
	_bound_shape = $Boundary.shape
	_bound_shape.radius = bound_radius
	_bound_shape.height = bound_height
	
	#Setup colision appearance
	$Boundary.translation.y = bound_height+bound_radius
	
	$Appearance/Side.translation.y = bound_height+bound_radius
	$Appearance/Side.height = bound_height
	$Appearance/Side.radius = bound_radius
	
	$Appearance/Bottom.translation.y = bound_radius+bound_height/2
	$Appearance/Bottom.radius = bound_radius
	
	$Appearance/Top.translation.y = bound_radius+bound_height/2+bound_height
	$Appearance/Top.radius = bound_radius
	#$Appearance.translation.y = 10
	pass

###############################################################
#	MODULAR FUNCTIONS
###############################################################

###############################################################
#	APPLICATION FUNCTIONS
###############################################################

# Called when the node enters the scene tree for the first time.
func _ready():
	_setup_col_bound()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	pass

func _physics_process(delta):
	self.move_and_slide(_motion)
	pass
