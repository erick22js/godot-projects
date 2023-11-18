extends Node

const srcCountriesImg = "res://imgs/territory/";
var countriesImg = {};

#area é =>  (area real / 1000) arredondado até a casa da centena
var countries = {
	"Austrália":{"x":2734, "y":1263, "area":7700},
	"Brasil":{"x":916, "y":1095, "area":8500},
	"Canadá":{"x":251, "y":177, "area":9900},
	"China":{"x":2357, "y":524, "area":9500},
	"Estados Unidos":{"x":0, "y":305, "area":9300},
	"México":{"x":493, "y":786, "area":1900},
	"Rússia":{"x":1874,"y":242, "area":17000}
}

var ADMs = {};

func loadCountriesImg():
	for country in countries:
		print(country);
		countriesImg[country] = load(srcCountriesImg+country+".png");
		pass

