extends Node2D

export (String)var specie;
export var type = "zombie";

export var animation_Mod = {};
export (String)var main_player;
var animation_last_index = 0;
export var animation_cycled = false;
export var projectiles_Mod = {};

export var properties = {};
export var constants = {};
export var behavior = {};

export var speed = .35;
export var speed_multiplier = .65;

var hittable = true;

export (GDScript)var settings;
export var points = {};

export (NodePath)var spaceGame;
export (NodePath)var audio_player;
var row_plants = [];
var row_zombies = [];

# Called when the node enters the scene tree for the first time.
func _ready():
	#Setting zombie
	var get_settings = Util.readJsonFile("res://packages/Zombies/zombie.json");
	behavior = get_settings.states;
	constants = get_settings.constants;
	properties = get_settings.properties;
	
	#preset
	$Body/body_animation.play("walking");
	$Body/ColisionOBJ.set("type","zombie");
	$Body/body_animation.playback_speed = speed_multiplier;
	speed *= speed_multiplier;
	#$Body/ColisionOBJ.
	#Reload zombie components
	for i in points.keys():
		points[i] = get_node(points[i]);
	for i in animation_Mod.keys():
		animation_Mod[i] = get_node(animation_Mod[i]);
	main_player = animation_Mod[main_player];
	animation_Mod["body"].play("idle");
	spaceGame = get_node(spaceGame);
	audio_player = get_node(audio_player);
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if main_player.current_animation_position >= main_player.current_animation_length*.5 and animation_last_index <= main_player.current_animation_length*.5:
		on_middle_animation_cycle()
	if main_player.current_animation_position <= animation_last_index:
		on_end_animation_cycle()
	animation_last_index = main_player.current_animation_position;
	
	self.z_index = self.position.y;
	execute(delta);
	processEvents();
	pass

func execute(delta):
	var i = behavior[properties.state];
	runAnimation();
	match i.action:
		"walk":
			self.position.x -= speed*i.speed_multiplier;
	pass

func runAnimation():
	var i = behavior[properties.state];
	if i.has("animation"):
		#$Body/body_animation.
		animation_Mod[i.animation.from].play(i.animation.play)
	pass

func processEvents():
	#Detect plant and begin hit
	if !properties.state=="#eating":
		for i in $Body/ColisionOBJ.get_overlapping_areas():
			if(i.getEntity().type=="plant" and i.getEntity().live):
				properties.state = "#eating"
				properties.targetPlant = i.getEntity();
				
	pass

func action(exec):
	
	pass

func dealDamage(damage, effect):
	$Body/effect.play("damage");
	properties.health -= damage;
	if properties.health <= 0:
		kill(effect);
	#$Body/head.queue_free();
	#hittable = false;
	return
func kill(effect):
	row_zombies.erase(self);
	$sound_player.deactivate_audio();
	queue_free();
	pass

func eat_targered_plant():
	if properties.state=="#eating":
		properties.targetPlant.dealDamage(0, "");
		if !properties.targetPlant.live:
			properties.state = "walking";
			properties.targetPlant = null;

func on_end_animation_cycle():
	eat_targered_plant()
	if behavior[properties.state].has("on_end_cycle"):
		action(behavior[properties.state].on_end_cycle);
	pass # Replace with function body.

func on_middle_animation_cycle():
	eat_targered_plant()
	if behavior[properties.state].has("on_middle_cycle"):
		action(behavior[properties.state].on_middle_cycle);
	pass
