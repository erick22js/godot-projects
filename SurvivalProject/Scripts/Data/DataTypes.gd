extends Node

enum BlockType{
	
}

enum{
	SOLID,
	#Textures
	TOP,
	BOTTOM,
	LEFT,
	RIGHT,
	FRONT,
	BACK
}

const Blocks = {
	"air":{
		SOLID: false,
	},
	"grass":{
		SOLID: true,
		TOP: Vector2(1, 0), BOTTOM: Vector2(12, 0), LEFT: Vector2(1, 1), 
		RIGHT: Vector2(1, 1), FRONT: Vector2(1, 1),  BACK: Vector2(1, 1),
	},
	"dirt":{
		SOLID: true,
		TOP: Vector2(12, 0), BOTTOM: Vector2(12, 0), LEFT: Vector2(12, 0), 
		RIGHT: Vector2(12, 0), FRONT: Vector2(12, 0),  BACK: Vector2(12, 0),
	},
	"stone":{
		SOLID: true,
		TOP: Vector2(35, 0), BOTTOM: Vector2(35, 0), LEFT: Vector2(35, 0), 
		RIGHT: Vector2(35, 0), FRONT: Vector2(35, 0),  BACK: Vector2(35, 0),
	}
}
