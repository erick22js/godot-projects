extends Spatial


# Walk motioning
var wm_enabled := false
var wm_position := Vector3(0, 0, 0)
var wm_hurry := 1.0


# Called when the node enters the scene tree for the first time.
func _ready():
	wm_enabled = true
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(wm_enabled):
		if wm_position.distance_to(self.translation)<($Body.speed*delta*1.5*wm_hurry):
			self.translation.x = wm_position.x
			self.translation.z = wm_position.z
			wm_enabled = false
		else:
			var step := (wm_position-self.translation).normalized()
			$Body.phy_torque = step*wm_hurry
		pass
	pass
