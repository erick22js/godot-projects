extends Spatial

# Human physicals
var speed = 2

# Physical properties
export var body_node:NodePath
var body:KinematicBody = null
var phy_forces := Vector3(0, -4, 0)
var phy_torque := Vector3(0, 0, 0)
var phy_velocity := Vector3(0, 0, 0)


func _ready():
	body = get_node(body_node)
	pass


func _process(delta):
	
	pass


func _physics_process(delta):
	# Apply torque
	body.move_and_slide(phy_torque*speed)
	phy_torque = Vector3()
	
	# Apply acceleration
	phy_velocity += phy_forces*delta
	body.move_and_slide(phy_velocity)
	if(body.is_on_floor()):
		phy_velocity.y = 0
	
	pass
