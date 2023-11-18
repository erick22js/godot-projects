extends Node

export (String)var specie;
export var type = "plant";

export var animation_Mod = {};
export (String)var main_player;
var animation_last_index = 0;
export var projectiles_Mod = {};

export var properties = {};
export var constants = {};
export var behavior = {};

export var points = {};

export (NodePath)var spaceGame;
export (NodePath)var audio_player;
var rows_plants = [];
var row_zombies = [];
var act_row = 0;
var act_collumm = 0;

var live = true;
var has_detected_zombie = false;
var detected_directions = [];

func _ready():
	#Apply to plant
	self.z_index = self.position.y;
	
	#Setting plant
	var get_settings = Util.readJsonFile("res://packages/Plants/peashooter.json");
	behavior = get_settings.behavior;
	constants = get_settings.constants;
	properties = get_settings.properties;
	for v in constants.sight.directions:
		detected_directions.append(false);
	
	#Reload plant components
	for i in points.keys():
		points[i] = get_node(points[i]);
	for i in animation_Mod.keys():
		animation_Mod[i] = get_node(animation_Mod[i]);
	animation_Mod["body"].play("idle");
	spaceGame = get_node(spaceGame);
	audio_player = get_node(audio_player);
	main_player = animation_Mod[behavior[properties.state][0].animation.from];
	pass

func _process(delta):
	#print(detected_directions)
	#if (
	#	main_player.current_animation_position >= main_player.current_animation_length*.5 
	#	and animation_last_index <= main_player.current_animation_length*.5):
	#	pass
	#if main_player.current_animation_position <= animation_last_index:
	#	on_end_animation_cycle()
	animation_last_index = main_player.current_animation_position;
	
	
	if !has_detected_zombie:
		has_detected_zombie = detectSights();
	
	execute(delta);
	pass

#Process Plant behaviors
func execute(delta):
	if(!live):
		destroy()
	for k in behavior[properties.state]:
		if process_condition(k, delta):
			process_animation(k);
			match k.event.action:
				"shoot":
					audio_player.stream = DataAudios.STREAMS["shoot2"];
					
					audio_player.play();
					for p in k.event.shoots:
						spawn_object(Util.degressToRadian(p.direction));
					resetDetection()
	pass

func process_animation(behavior):
	if behavior.has("animation"):
		animation_Mod[behavior.animation.from].play(behavior.animation.play);
	pass

func process_condition(behavior, delta):
	if behavior.condition.has("sight_zombie"):
		var flag = detected_directions[behavior.condition.sight_zombie[0]];
		for i in behavior.condition.sight_zombie:
			flag = flag or detected_directions[i];
		if !flag:
			return false
	if behavior.condition.has("recharged"):
		if properties[behavior.condition.recharged] <= 0:
			if behavior.condition.has("reset_recharged"):
				properties[behavior.condition.recharged] = properties[behavior.condition.reset_recharged]
		else:
			properties[behavior.condition.recharged] -= delta
			return false
	if behavior.condition.has("sight_zombie"):
		if !has_detected_zombie:
			return false
	return true;

#Plant Behaviors
func spawn_object(angle):
	var obj = projectiles_Mod["pea"].instance();
	obj.position.x = points.mouth.global_position.x;
	obj.position.y = points.mouth.global_position.y;
	obj.z_index = self.z_index+1;
	obj.speed = 4;
	obj.angle = angle;
	get_parent().add_child(obj);
	pass


func dealDamage(damage, effect):
	animation_Mod.effect.play("damage");
	properties.health -= damage;
	if properties.health <= 0:
		kill(effect)
		return true
	#$Body/head.queue_free();
	#hittable = false;
	return false
func kill(effect):
	live = false;
	#queue_free();
	pass
func destroy():
	rows_plants[act_row][act_collumm].erase(self);
	audio_player.deactivate_audio();
	queue_free();
	pass

func on_middle_animation_cycle():
	pass
func on_end_animation_cycle():
	pass

func resetDetection():
	for i in range(detected_directions.size()):
		detected_directions[i] = false;
	has_detected_zombie = false;
func detectSights():
	var d = 0;
	var flag = false;
	for s in constants.sight.directions:
		if anyZombieInSightView(Util.degressToRadian(s)):
			detected_directions[d] = true;
			flag = true;
		d += 1;
	return flag;
func anyZombieInSightView(direction_sight):
	var detected = false;
	for z in row_zombies:
		if zombieInSightView(z, direction_sight, 1000):
			detected = true;
	return detected
func zombieInSightView(zombie, direction_plant, distance):
	var angle_get = Util.angle(self.position, zombie.position);
	var distance_get = Util.distance(self.position, zombie.position);
	return (angle_get <= .1+direction_plant and angle_get >= -.1+direction_plant) and distance_get < constants.sight.distance*10;
