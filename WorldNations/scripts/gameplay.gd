extends Node2D

var ticks = 0;
var ticksMax = 1;

func _ready():
	#Initialize all countries and his potency
	for c in DataCountries.countries:
		var nc = DataCountries.countries[c].name;
		var dat = DataCountries.countries[c];
		DataCountries.ADMs[nc] = {
			"name": nc,
			"ind": c,
			"x": DataCountries.countries[c].x+DataCountries.countriesImg[c].get_width()*.5,
			"y": DataCountries.countries[c].y+DataCountries.countriesImg[c].get_height()*.5,
			"relations": {},
			"team": 1 if !dat.has("team") else dat["team"], #Index team
			"selected": false,
			"floatingY": 0,
			#Economy
			"money": 500 if !dat.has("money") else dat["money"],
			"materials": 0,
			"products":[],
			#Population
			"population": 2 if !dat.has("population") else dat["population"],
			"satisfaction": 0,
			"army": 0 if !dat.has("army") else dat["army"], #Exército
			#Buildings
			"houses": 3 if !dat.has("houses") else dat["houses"],
			"services": 1 if !dat.has("services") else dat["services"],
			"commerce": 4 if !dat.has("commerce") else dat["commerce"],
			"industry": 1 if !dat.has("industry") else dat["industry"],
			
			#CPU mechanics
			"focus":"grow_city",
			"needFocus":false,
			"commercialPlan":{
				"retrieveMoney":{
					"services": .02+Util.random(0,.73),
					"industry": .02+Util.random(0,.73),
				},
				"invest":{
					"houses": 0.05+Util.random(0,1.45)
				}
			}
			
		}
	pass # Replace with function body.

func _process(delta):
	ticks+=delta;
	var updateScenario = ticks>=ticksMax;
	#Update countries
	for i in DataCountries.ADMs:
		DataCountries.ADMs[i].floatingY += ((5 if DataCountries.ADMs[i].floatingY < 25 else 0) if DataCountries.ADMs[i].selected else (-5 if DataCountries.ADMs[i].floatingY > 0 else 0))
		if updateScenario:
			ADMwork.updateCountry(DataCountries.ADMs[i]);
	if updateScenario:
		ticks = 0;
		#Update Date
		Data.day += 1;
		if Data.day > 30:
			Data.day = 1;
			Data.mounth += 1;
			if Data.mounth > 12:
				Data.mounth = 1;
				Data.year += 1;
		#GlobalCamera.updateCountryInfo(DataCountries.ADMs[GlobalCamera.selected]);
	pass
