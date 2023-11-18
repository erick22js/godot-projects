extends CanvasModulate


func _ready():
	DataCountries.loadCountriesImg();
	
	
	pass # Replace with function body.

func _process(delta):
	update();
	pass

func _draw():
	
	#Draw countries around map
	for c in DataCountries.countries:
		var co = DataCountries.ADMs[c]
		var x = DataCountries.countries[c].x;
		var y = DataCountries.countries[c].y;
		var yn = 0;
		while yn<DataCountries.ADMs[c].floatingY:
			draw_texture(DataCountries.countriesImg[c],Vector2(x, y-yn), Color(.3, .3, .3, 1));
			yn += 2;
		draw_texture(DataCountries.countriesImg[c],Vector2(x, y-co.floatingY),
			Color(.5, .5, .5, 1) if co.team==Data.nobody else Data.Teams[co.team][1]
			);
	pass

