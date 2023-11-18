extends Node

export var speed = 4;
export var angle = 0;
export var type = "projectile";

export var damage = 0;

export var row_zombies = [];

func _ready():
	pass # Replace with function body.

func _process(delta):
	#print(Util.quantitypeas);
	if outOfView():
		destroy();
	if self.visible:
		self.position.x += cos(angle)*speed;
		self.position.y += sin(angle)*speed;
		for i in $form/ColisionOBJ.get_overlapping_areas():
			if(i.getEntity().type=="zombie"):
				if(i.getEntity().hittable):
					i.getEntity().dealDamage(damage, "");
					$sound_player.play();
					$sound_player.seek(0.06)
					self.visible = false;
					break
	pass

func outOfView():
	var absX = self.position.x;
	var absY = self.position.y;
	var out_hor = absX < -50 or absX > 950;
	var out_ver = absY < -50 or absY > 650;
	return out_hor or out_ver;

func destroy():
	$sound_player.deactivate_audio();
	queue_free();
	

