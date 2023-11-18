extends Control


var keywords = {
	"reserved": [
		"implement",
		"const", "bool", "int", "real", "string", "object",
		"void", "function", "override",
		"while", "do", "for", "in",
		"break", "continue", "return",
	],
	"builtin-value": [
		"true", "false", "null", "infinite", "nan",
		"PI", "TAU"
	],
	"builtin-function": [
		
	],
}

# Called when the node enters the scene tree for the first time.
func _ready():
	var hl:CodeHighlighter = $Input.syntax_highlighter
	$Input.indent_size = 8
	
	# Comment settings
	$Input.add_comment_delimiter("//", "", true)
	hl.add_color_region("//", "", Color(0.4, 0.4, 0.4, 1.0), true)
	$Input.add_comment_delimiter("/*", "*/", false)
	hl.add_color_region("/*", "*/", Color(0.4, 0.4, 0.4, 1.0), false)
	
	# String settings
	$Input.add_string_delimiter("\"", "\"", false)
	hl.add_color_region("\"", "\"", Color(0.7, 0.4, 0.0, 1.0), false)
	$Input.add_string_delimiter("\'", "\'", false)
	hl.add_color_region("\'", "\'", Color(0.7, 0.4, 0.0, 1.0), false)
	
	# Syntax settings
	for w in keywords["reserved"]:
		hl.add_keyword_color(w, Color(0.8, 0.2, 0.6, 1.0))
	for w in keywords["builtin-value"]:
		hl.add_keyword_color(w, Color(0.7, 0.2, 0.2, 1.0))
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
