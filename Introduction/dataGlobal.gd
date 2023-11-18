extends Node

var quantity := 0;

func run_script(input):
	var script = GDScript.new()
	script.set_source_code("func eval():" + input)
	script.reload()
	var obj = Reference.new()
	#var obj = Node.new() #So we can call get_node
	obj.set_script(script)
	add_child(obj)
	var ret_val = obj.eval()
	remove_child(obj)
	return ret_val
	pass
