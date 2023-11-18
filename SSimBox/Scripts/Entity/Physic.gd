extends KinematicBody

tool

###############################################################
#	PROPERTIES
###############################################################

#	Physic properties
export var _gravity:float = 1
export var _mass:float = 1
export var _motion:Vector3 = Vector3(0.0, 0.0, 0.0);

###############################################################
#	BACK FUNCTIONS
###############################################################

###############################################################
#	MODULAR FUNCTIONS
###############################################################

###############################################################
#	APPLICATION FUNCTIONS
###############################################################

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	pass

func _physics_process(delta):
	self.move_and_slide(_motion)
	pass
