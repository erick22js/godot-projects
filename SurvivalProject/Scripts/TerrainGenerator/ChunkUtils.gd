extends Node

const cubeVertices = [
	Vector3(0, 0, 0),
	Vector3(1, 0, 0),
	Vector3(0, 1, 0),
	Vector3(1, 1, 0),
	Vector3(0, 0, 1),
	Vector3(1, 0, 1),
	Vector3(0, 1, 1),
	Vector3(1, 1, 1),
]

const cubeFaces = {
	"top":[2, 3, 7, 6],
	"bottom":[0, 4, 5, 1],
	"left":[2, 6, 4, 0],
	"right":[7, 3, 1, 5],
	"front":[6, 7, 5, 4],
	"back":[3, 2, 0, 1],
}

