extends Node2D

var peashooter = load("res://Objects/Plants/Peashooter.tscn");

var zombie = load("res://Objects/Zombies/Zombie.tscn");

var plants_rows = [];
var zombies_rows = [];

var delaySpawn = 3;

onready var  GRID_HANDDLER = $GridHanddler;

func _ready():
	for r in range(5):
		plants_rows.append([]);
		for c in range(9):
			plants_rows[r].append([]);
	
	pass # Replace with function body.


func _process(delta):
	delaySpawn -= delta;
	if delaySpawn <= 0:
		put_zombie(9.5, int(Util.random(5)));
		delaySpawn = 500005;
	pass

func _input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			#var x = event.position.x-208;
			#x = int(x/69.0);
			#var y = event.position.y-144;
			#y = int(y/81.6);
			var backed = evalLawnIndex(event.position.x, event.position.y);
			print(backed);
			put_plant(backed.x, backed.y);
	

func evalLawnIndex(x, y):
	var width = GRID_HANDDLER.rect_size.x;
	var height = GRID_HANDDLER.rect_size.y;
	var backedX = x-GRID_HANDDLER.rect_position.x;
	var backedY = y-GRID_HANDDLER.rect_position.y;
	backedX = int(backedX/width);
	backedY = int(backedY/height);
	return Vector2(backedX, backedY);

func evalLawnPosition(c, r):
	var posX = GRID_HANDDLER.rect_position.x+(c+.5)*GRID_HANDDLER.rect_size.x;
	var posY = GRID_HANDDLER.rect_position.y+(r+.65)*GRID_HANDDLER.rect_size.y;
	return Vector2(posX, posY);

func put_plant(c, r):
	var np = peashooter.duplicate(true);
	np = np.instance();
	np.position.x = evalLawnPosition(c, r).x;
	np.position.y = evalLawnPosition(c, r).y;
	plants_rows[r][c].append(np);
	np.rows_plants = plants_rows;
	np.row_zombies = zombies_rows;
	np.act_row = r;
	np.act_collumm = c;
	np.name = "peashooter"+str(np.position.x)+str(np.position.y);
	add_child(np);

func put_zombie(c, r):
	var nz = zombie.duplicate(true);
	nz = nz.instance();
	nz.position.x = evalLawnPosition(c, r).x;
	nz.position.y = evalLawnPosition(c, r).y;
	zombies_rows.append(nz);
	nz.row_zombies = zombies_rows;
	nz.row_plants = plants_rows[r];
	add_child(nz);
