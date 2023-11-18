extends Camera3D


var map = {}


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var vel := 12.0
	if map.has(KEY_W) && map[KEY_W]:
		var vec := Vector3(0, 0, -1)*vel
		self.translate(vec)
	if map.has(KEY_A) && map[KEY_A]:
		var vec := Vector3(-1, 0, 0)*vel
		self.translate(vec)
	if map.has(KEY_S) && map[KEY_S]:
		var vec := Vector3(0, 0, 1)*vel
		self.translate(vec)
	if map.has(KEY_D) && map[KEY_D]:
		var vec := Vector3(1, 0, 0)*vel
		self.translate(vec)
	pass

func _input(event):
	if event is InputEventKey:
		map[event.keycode] = event.pressed
	if event is InputEventMouseMotion:
		self.rotation.x -= event.relative.y / 150
		self.rotation.y -= event.relative.x / 150
		self.rotation.x = -PI/2 if self.rotation.x < -PI/2 else PI/2 if self.rotation.x > PI/2 else self.rotation.x
