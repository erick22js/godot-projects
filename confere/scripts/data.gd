extends Node

#Constants
var RESOLUTION_HEIGHT;
var RESOLUTION_WIDTH;

#Relations States
var friendly = "FRIENDLY";
var enemy = "ENEMY";
var neutral = "NEUTRAL";

#Teams type
var nobody = -1;
var Teams = [
	["Player", Color(0, 1, 1, 1)],
	["CPU1", Color(1, 0, 0, 1)]
]


#GLOBAL DATA
var selected = "";
var layout = "gameplay";
var day = 1;
var mounth = 1;
var year = 1900;
