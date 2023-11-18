extends "../FPSGun.gd"


func _ready():
	pass

func _process(delta):
	pass

func GUN_atack()->int:
	.GUN_atack()
	$AnimationPlayer.play("Shoots", -1, 1.0, false)
	return 0
