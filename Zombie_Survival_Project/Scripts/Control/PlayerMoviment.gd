extends KinematicBody

const GunHolder = preload("res://Scripts/Gameplay/GunBehaviors/GunHolder.gd")

########################################################
# @PROPERTIES SECTION
########################################################

#Main properties and modules
var maxSpeed := 16.0
var jumpForce := 20.0
var playerMass := 1.0

#Nodes and references
export var cam_node:NodePath
var camera:Camera
export var gholder_node:NodePath
var gholder:GunHolder

#Hidden and flag control variables
var motionAdder := Vector3(0, 0, 0)
var jumped := false

########################################################
# @INTIALIZE SECTION
########################################################

func _ready():
	camera = get_node(cam_node)
	gholder = get_node(gholder_node)
	pass

########################################################
# @MAIN RUNTIME SECTION
########################################################

func _process(delta):
	#Head motion section
	camera.rotation.x += -deg2rad(GInput.mouse.my*.5)
	camera.rotation.x = -1 if camera.rotation.x<-1 else 1 if camera.rotation.x>1 else camera.rotation.x
	camera.rotation.y += -deg2rad(GInput.mouse.mx*.5)
	
	
	####################################################
	# @Motion Player
	var mVector = Vector3(0, 0, 0)
	if GInput.getKey(KEY_W):
		mVector.z += -1
		pass
	if GInput.getKey(KEY_S):
		mVector.z += 1
		pass
	if GInput.getKey(KEY_A):
		mVector.x += -1
		pass
	if GInput.getKey(KEY_D):
		mVector.x += 1
		pass
	mVector = mVector.rotated(Vector3(0, 1, 0), camera.rotation.y)
	move(mVector, maxSpeed)
	
	if GInput.getKeyOnce(KEY_SPACE):
		print("Jump!")
		jump()
	
	pass

########################################################
# @PHYSICS SECTION
########################################################

func _physics_process(delta):
	motionAdder.y -= 1*playerMass
	move_and_slide(motionAdder, Vector3.UP, true, PI*.5)
	if is_on_floor():
		motionAdder.y = 0
		jumped = false
	pass

########################################################
# @INPUTS SECTION
########################################################

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			gholder.atack()
	pass

########################################################
# @UTIL FUNCTIONS SECTION
########################################################

func move(vector:Vector3, multiplier:=1.0):
	motionAdder.x = vector.x*multiplier
	motionAdder.z = vector.z*multiplier
	pass

func jump(multiplier:=1.0):
	if not jumped:
		motionAdder.y = jumpForce
		jumped = true
