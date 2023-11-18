extends Node

const srcCountriesImg = "res://imgs/territory/";
var countriesImg = {};

#area é =>  (area real / 1000) arredondado até a casa da centena
var countries = {
	"australia":{"name":"Austrália","x":2734, "y":1263, "area":7700},
	"brasil":{
		"name":"Brasil","x":916, "y":1095, "area":8500, "team":0},
	#	,"team": 0, "money": 5000, "industry":1, "houses":5, "commerce":3
	#},
	"canada":{"name":"Canadá","x":251, "y":177, "area":9900},
	"china":{"name":"China","x":2357, "y":524, "area":9500},
	"egito":{"name":"Egito","x":1880, "y":800, "area":1000},
	"estadosunidos":{"name":"Estados Unidos","x":0, "y":305,"area":9300},
	#	,"team":1, "money": 1000, "industry":1, "houses":5, "commerce":3
	#},
	"franca":{"name":"França","x":1584, "y":584, "area":551},
	"india":{"name":"Índia","x":2304, "y":776, "area":3200},
	"inglaterra":{"name":"Inglaterra","x":1536, "y":488, "area":244},
	"italia":{"name":"Itália","x":1704, "y":624, "area":301},
	"mexico":{"name":"México","x":493, "y":786, "area":1900},
	"polonia":{"name":"Polônia","x":1776, "y":536, "area":323},
	"russia":{"name":"Rússia","x":1874,"y":242, "area":17000}
}

var ADMs = {};

func loadCountriesImg():
	for country in countries:
		print(country);
		countriesImg[country] = load(srcCountriesImg+country+".png");
		pass

