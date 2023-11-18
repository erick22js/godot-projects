extends Camera2D

var camera_animation = Vector2(0, 0);
var less_animation = 0;
var speed_animation = 6;
var execute_animation = false;
var ended_animation = false;
var delay = 2

# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.

func restart_animation(direction:Vector2):
	camera_animation = direction
	less_animation = abs(direction.x*256)+abs(direction.y*192)
	delay = .3;
	execute_animation = true;
	Settings.gameFreeze = true;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	ended_animation = false;
	if delay<=0:
		if less_animation >= (abs(camera_animation.x)+abs(camera_animation.y))*speed_animation:
			self.position += camera_animation*speed_animation;
			less_animation -= (abs(camera_animation.x)+abs(camera_animation.y))*speed_animation;
		else:
			if execute_animation:
				ended_animation = true;
			execute_animation = false
			Settings.gameFreeze = false;
	else:
		delay -= delta
	pass
