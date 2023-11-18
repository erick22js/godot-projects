extends Node2D


const Keys = {
	"horizontal": 0,
	"vertical": 0,
	"left": false,
	"right": false,
	"top": false,
	"down": false,
}

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _input(event):
	if event is InputEventKey:
		#print(event)
		if event.is_pressed():
			if event.scancode == KEY_D:
				Keys.right = true
			if event.scancode == KEY_A:
				Keys.left = true
			if event.scancode == KEY_W:
				Keys.top = true
			if event.scancode == KEY_S:
				Keys.down = true
		else:
			if event.scancode == KEY_D:
				Keys.right = false
			if event.scancode == KEY_A:
				Keys.left = false
			if event.scancode == KEY_W:
				Keys.top = false
			if event.scancode == KEY_S:
				Keys.down = false
			pass
	Keys.horizontal = (1 if Keys.right else 0)-(1 if Keys.left else 0);
	Keys.vertical = (1 if Keys.down else 0)-(1 if Keys.top else 0);
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
