extends Control


# Properties
var proj_map:EditorMap = null

# Called when the node enters the scene tree for the first time.
func _ready():
	# Generating a new project and sharing with each component
	proj_map = EditorMap.new()
	$Display.proj_map = proj_map
	$Display/Canvas.proj_map = proj_map
	
	# Setup scene
	#set_process_shortcut_input(false)
	#set_process_unhandled_input(false)
	#set_process_unhandled_key_input(false)
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _onTestButtonPressed():
	#get_tree().change_scene_to_file("res://scenes/GameRuntime.tscn")
	
	visible = false
	get_parent().get_node("Space").commit(proj_map)
	
	pass # Replace with function body.
