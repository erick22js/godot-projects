extends Node


const map = {
	"points": [
		{ "x": 0, "y": -150 },
		{ "x": 100, "y": -100 },
		{ "x": 150, "y": 0 },
		{ "x": 100, "y": 100 }, #
		{ "x": 0, "y": 150 }, #
		{ "x": -100, "y": 100 },
		{ "x": -150, "y": 0 },
		{ "x": -100, "y": -100 },
		
		{ "x": 300, "y": -300 },
		{ "x": 500, "y": 50 },
		
		# 10
		{ "x": 152, "y": 176 },
		{ "x": 48, "y": 224 },
		
		{ "x": -75, "y": 325 },
		{ "x": -75, "y": 200 },
		
		{ "x": -250, "y": 200 },
		{ "x": -150, "y": 150 },
		
		{ "x": -275, "y": 75 },
		{ "x": -175, "y": 50 },
		
		{ "x": -275, "y": -100 },
		{ "x": -175, "y": 0 },
		{ "x": -175, "y": -175 },
	],
	"linedefs": [
		{ "id": -1, "p1": 0, "p2": 1 },
		{ "id": -1, "p1": 1, "p2": 2 },
		{ "id": -1, "p1": 2, "p2": 3 },
		{ "id": -1, "p1": 3, "p2": 4 },
		{ "id": -1, "p1": 4, "p2": 5 },
		{ "id": -1, "p1": 5, "p2": 6 },
		{ "id": -1, "p1": 6, "p2": 7 },
		{ "id": -1, "p1": 7, "p2": 0 },
		
		{ "id": -1, "p1": 1, "p2": 8 },
		{ "id": -1, "p1": 8, "p2": 9 },
		{ "id": -1, "p1": 9, "p2": 2 },
		
		# 11
		{ "id": -1, "p1": 3, "p2": 10 },
		{ "id": -1, "p1": 10, "p2": 11 },
		{ "id": -1, "p1": 11, "p2": 4 },
		
		# 14
		{ "id": -1, "p1": 11, "p2": 12 },
		{ "id": -1, "p1": 12, "p2": 13 },
		{ "id": -1, "p1": 13, "p2": 4 },
		
		# 17
		{ "id": -1, "p1": 12, "p2": 14 },
		{ "id": -1, "p1": 14, "p2": 15 },
		{ "id": -1, "p1": 15, "p2": 13 },
		
		# 20
		{ "id": -1, "p1": 14, "p2": 16 },
		{ "id": -1, "p1": 16, "p2": 17 },
		{ "id": -1, "p1": 17, "p2": 15 },
		
		# 23
		{ "id": -1, "p1": 16, "p2": 18 },
		{ "id": -1, "p1": 18, "p2": 19 },
		{ "id": -1, "p1": 19, "p2": 17 },
		
		# 26
		{ "id": -1, "p1": 18, "p2": 20 },
		{ "id": -1, "p1": 20, "p2": 7 },
		{ "id": -1, "p1": 6, "p2": 19 },
	],
	"sidedefs": [
		# Sector 0: Sides
		{ "line": 0, "right": true, "faces": [
			{}
		] },
		{ "line": 1, "right": true, "faces": [
			{}, { "portal": 1, "hidden": true }, {}
		] },
		{ "line": 2, "right": true, "faces": [
			{}
		] },
		{ "line": 3, "right": true, "faces": [
			{}, { "portal": 3, "hidden": true }, {}
		] },
		{ "line": 4, "right": true, "faces": [
			{}
		] },
		{ "line": 5, "right": true, "faces": [
			{}
		] },
		{ "line": 6, "right": true, "faces": [
			{}, { "portal": 8, "hidden": true } , {}
		] },
		{ "line": 7, "right": true, "faces": [
			{}
		] },
		
		# Sector 1: Sides
		{ "line": 8, "right": true, "faces": [
			{}
		] },
		{ "line": 9, "right": true, "faces": [
			{}
		] },
		{ "line": 10, "right": true, "faces": [
			{}
		] },
		{ "line": 1, "right": false, "faces": [
			{}, { "portal": 0, "hidden": true } , {}, { "portal": 2, "hidden": true }, {}
		] },
		
		# Sector 2: Sides
		{ "line": 0, "right": true, "faces": [
			{}
		] },
		{ "line": 1, "right": true, "faces": [
			{}, { "portal": 1, "hidden": true }, {}
		] },
		{ "line": 2, "right": true, "faces": [
			{}
		] },
		{ "line": 3, "right": true, "faces": [
			{}, { "portal": 3, "hidden": true } , {}
		] },
		{ "line": 4, "right": true, "faces": [
			{}
		] },
		{ "line": 5, "right": true, "faces": [
			{}
		] },
		{ "line": 6, "right": true, "faces": [
			{}
		] },
		{ "line": 7, "right": true, "faces": [
			{}
		] },
		
		# Sector 3: Sides
		{ "line": 11, "right": true, "faces": [
			{}
		] },
		{ "line": 12, "right": true, "faces": [
			{}
		] },
		{ "line": 13, "right": true, "faces": [
			{}, { "portal": 4, "hidden": true } , {}
		] },
		{ "line": 3, "right": false, "faces": [
			{}, { "portal": 2, "hidden": true } , {}
		] },
		
		# Sector 4: Sides
		{ "line": 14, "right": true, "faces": [
			{}
		] },
		{ "line": 15, "right": true, "faces": [
			{}, { "portal": 5, "hidden": true } , {}
		] },
		{ "line": 16, "right": true, "faces": [
			{}
		] },
		{ "line": 13, "right": false, "faces": [
			{}, { "portal": 3, "hidden": true } , {}
		] },
		
		# Sector 5: Sides
		{ "line": 17, "right": true, "faces": [
			{}
		] },
		{ "line": 18, "right": true, "faces": [
			{}, { "portal": 6, "hidden": true } , {}
		] },
		{ "line": 19, "right": true, "faces": [
			{}
		] },
		{ "line": 15, "right": false, "faces": [
			{}, { "portal": 4, "hidden": true } , {}
		] },
		
		# Sector 6: Sides
		{ "line": 20, "right": true, "faces": [
			{}
		] },
		{ "line": 21, "right": true, "faces": [
			{}, { "portal": 7, "hidden": true } , {}
		] },
		{ "line": 22, "right": true, "faces": [
			{}
		] },
		{ "line": 18, "right": false, "faces": [
			{}, { "portal": 5, "hidden": true } , {}
		] },
		
		# Sector 7: Sides
		{ "line": 23, "right": true, "faces": [
			{}
		] },
		{ "line": 24, "right": true, "faces": [
			{}, { "portal": 8, "hidden": true } , {}
		] },
		{ "line": 25, "right": true, "faces": [
			{}
		] },
		{ "line": 21, "right": false, "faces": [
			{}, { "portal": 6, "hidden": true } , {}
		] },
		
		# Sector 8: Sides
		{ "line": 26, "right": true, "faces": [
			{}
		] },
		{ "line": 27, "right": true, "faces": [
			{}
		] },
		{ "line": 6, "right": false, "faces": [
			{}, { "portal": 0, "hidden": true } , {}
		] },
		{ "line": 28, "right": true, "faces": [
			{}
		] },
		{ "line": 24, "right": false, "faces": [
			{}, { "portal": 7, "hidden": true } , {}
		] },
	],
	"shapes": [
		[0, 1, 2, 3, 4, 5, 6, 7],
		[1, 8, 9, 2],
		[3, 10, 11, 4],
		[11, 12, 13, 4],
		[12, 14, 15, 13],
		[14, 16, 17, 15],
		[16, 18, 19, 17],
		[18, 20, 7, 6, 19]
	],
	"subsectors": [
		{
			"sides": [0, 1, 2, 3, 4, 5, 6, 7],
			"shape": 0
		},
		{
			"sides": [8, 9, 10, 11],
			"shape": 1
		},
		{
			"sides": [12, 13, 14, 15, 16, 17, 18, 19],
			"shape": 0
		},
		{
			"sides": [20, 21, 22, 23],
			"shape": 2
		},
		{
			"sides": [24, 25, 26, 27],
			"shape": 3
		},
		{
			"sides": [28, 29, 30, 31],
			"shape": 4
		},
		{
			"sides": [32, 33, 34, 35],
			"shape": 5
		},
		{
			"sides": [36, 37, 38, 39],
			"shape": 6
		},
		{
			"sides": [40, 41, 42, 43, 44],
			"shape": 7
		}
	],
	"sectors": [
		{
			"floor_height": -80,
			"ceil_height": 100,
			"subsectors": [0]
		},
		{
			"floor_height": -40,
			"ceil_height": 340,
			"subsectors": [1]
		},
		{
			"floor_height": 160,
			"ceil_height": 380,
			"subsectors": [2]
		},
		{
			"floor_height": 120,
			"ceil_height": 350,
			"subsectors": [3]
		},
		{
			"floor_height": 80,
			"ceil_height": 300,
			"subsectors": [4]
		},
		{
			"floor_height": 40,
			"ceil_height": 270,
			"subsectors": [5]
		},
		{
			"floor_height": 0,
			"ceil_height": 220,
			"subsectors": [6]
		},
		{
			"floor_height": -20,
			"ceil_height": 190,
			"subsectors": [7]
		},
		{
			"floor_height": -40,
			"ceil_height": 140,
			"subsectors": [8]
		}
	]
}
