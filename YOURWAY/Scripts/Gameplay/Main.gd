extends Node2D

onready var Display = $Display;
onready var Player = $Drawables/Objects/Player;
onready var Ceil = $Drawables/Ground;

var loadedMapPart:Array = [];

# Called when the node enters the scene tree for the first time.
func _ready():
	print("start");
	renderCeils(Vector2(0,0))
	for x in range(5, 12):
		for y in range(5, 9):
			$Drawables/Cliffs.set_cell(x, y, 0)
	$Drawables/Cliffs.update_bitmask_region()
	for x in range(8, 16):
		for y in range(2, 13):
			$Drawables/Cliffs.set_cell(x, y, 0)
	$Drawables/Cliffs.update_bitmask_region()
	$Drawables/Cliffs2.update_bitmask_region()
	#Ceil.set_cell(0, 0, 1)
	pass # Replace with function body.


func renderCeils(Direction:Vector2):
	Settings.PlayerQuad += Direction;
	var part := TerrainGenerator.detectTerrainPart(Settings.PlayerQuad);
	for x in range(16):
		for y in range(12):
			Ceil.set_cell(x+Direction.x*16, y+Direction.y*12, part[x][y])
	loadedMapPart = part;

func detectPlayerOut():
	if Player.position.x < -4:
		return Vector2(-1, 0);
	elif Player.position.x > 260:
		return Vector2(1, 0);
	elif Player.position.y < -4:
		return Vector2(0, -1);
	elif Player.position.y > 196:
		return Vector2(0, 1);
	return null

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var out = detectPlayerOut();
	if Display.ended_animation:
		Display.position = Vector2(128, 96)
		Player.position.x += -Display.camera_animation.x*256;
		Player.position.y += -Display.camera_animation.y*192;
		for x in range(16):
			for y in range(12):
				Ceil.set_cell(x, y, loadedMapPart[x][y])
	if !Display.ended_animation && !Display.execute_animation && out!=null:
		renderCeils(out)
		Display.restart_animation(out)
	pass
