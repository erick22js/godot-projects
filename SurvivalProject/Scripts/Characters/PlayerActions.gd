extends KinematicBody

var lookAngle = Vector2(0, 0)

var velocity = Vector3()
var chunk = Vector2(0, 0)
const moviment_speed = 10
const jump_force = 10
var gravity = 20

var grounded = false
var jumping = false

signal changedChunk
signal modifyChunk

func _ready():
	#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	pass

func _input(event):
	if event is InputEventMouseMotion:
		lookAngle += Vector2(deg2rad(-event.relative.x), deg2rad(-event.relative.y))
		lookAngle.y = PI*.45 if lookAngle.y>PI*.45 else -PI*.45 if lookAngle.y<-PI*.45 else lookAngle.y
		$Head.rotation = Vector3()
		$Head.rotate_x(lookAngle.y)
		$Head.rotate_y(lookAngle.x)
		pass
	if event is InputEventKey:
		if event.scancode == KEY_SPACE:
			if event.pressed:
				jumping = true
			else:
				jumping = false
	pass

func _process(delta):
	var updatedChunk = Vector2(floor(translation.x/MapGenerator.chunkDimensions.x), floor(translation.z/MapGenerator.chunkDimensions.z))
	if(updatedChunk.x!=chunk.x or updatedChunk.y!=chunk.y):
		print("Changing chunk")
		chunk = updatedChunk
		emit_signal("changedChunk")
	pass

func _physics_process(delta):
	translation.y *= -2 if translation.y<-96 else 1
	$Head/Eyes/Node2D/DebugTextInfo.text = ""+\
		"Position = {x:"+str(translation.x)+" y:"+str(translation.y)+" z:"+str(translation.z)+"}\n"+\
		"PosFloor = {x:"+str(floor(translation.x))+" y:"+str(floor(translation.y))+" z:"+str(floor(translation.z))+"}"
	var dirMul = $Head.get_global_transform().basis
	var direction = Vector3()
	if Input.is_action_pressed("Move_front"):
		direction -= Vector3(sin(lookAngle.x), 0, cos(lookAngle.x))
	if Input.is_action_pressed("Move_back"):
		direction += Vector3(sin(lookAngle.x), 0, cos(lookAngle.x))
	if Input.is_action_pressed("Move_left"):
		direction -= Vector3(sin(lookAngle.x+PI*.5), 0, cos(lookAngle.x+PI*.5))
	if Input.is_action_pressed("Move_right"):
		direction += Vector3(sin(lookAngle.x+PI*.5), 0, cos(lookAngle.x+PI*.5))
	#Input.action_press()
	velocity.z = direction.z*moviment_speed
	velocity.x = direction.x*moviment_speed
	velocity.y -= gravity*delta
	if jumping and grounded:
		print("jump "+str(velocity.y))
		velocity.y = jump_force
	velocity = move_and_slide(velocity)
	grounded = velocity.y==0
	pass
