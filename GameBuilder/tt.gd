extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	
	var e = evaluate("""
var o = 5;

func diz():
	print("oi"+str(o))
""");
	e.diz();
	pass # Replace with function body.

func evaluate(input):
	var script = GDScript.new()
	script.set_source_code(input)
	script.reload()
	var obj = Reference.new()
	obj.set_script(script)
	return obj # Supposing input is "23 + 2", returns 25
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
