extends Spatial

const FPSGun = preload("res://Scripts/Gameplay/GunBehaviors/FPSGun.gd")

#Main properties and modules
export var offset := Vector3(0.7, 0, 1.0)
export var offsetY := 2.5

#Nodes and references
export var cam_node:NodePath
var camera:Camera
export var gun_node:NodePath
var gun:FPSGun

func _ready():
	camera = get_node(cam_node)
	swapGun(get_node(gun_node))
	pass

func _process(delta):
	followView(0.18, 0.18)
	pass

func followView(m_motion := 1.0, m_rotate := 1.0):
	var ideal_rot = Vector3(camera.rotation.x, camera.rotation.y, 0)
	var ideal_pos := offset.rotated(Vector3.UP, camera.rotation.y+PI*.5)
	ideal_pos.y = offsetY+camera.rotation.x
	self.translation += (ideal_pos-self.translation)*m_motion
	self.rotation += (ideal_rot-self.rotation)*m_rotate
	pass

func swapGun(nGun:FPSGun):
	gun = nGun
	pass

func atack():
	gun.GUN_atack()
	pass
