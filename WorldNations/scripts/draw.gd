extends CanvasModulate

export var entitiesSprites = {};

func _ready():
	DataCountries.loadCountriesImg();
	
	
	pass # Replace with function body.

func _process(delta):
	update();
	pass


func _draw():
	
	#Draw countries around map
	for c in DataCountries.countries:
		var cname = DataCountries.countries[c].name
		var co = DataCountries.ADMs[cname];
		var x = DataCountries.countries[c].x;
		var y = DataCountries.countries[c].y;
		var yn = 0;
		if !co.selected:
			draw_texture(DataCountries.countriesImg[c],Vector2(x, y-co.floatingY),
				Color(.5, .5, .5, 1) if co.team==Data.nobody else Data.Teams[co.team][1]
				);
	if Data.selected.name!=null:
		var x = DataCountries.countries[Data.selected.ind].x;
		var y = DataCountries.countries[Data.selected.ind].y;
		var yn = 0;
		while yn<Data.selected.floatingY:
			draw_texture(DataCountries.countriesImg[Data.selected.ind],Vector2(x, y-yn), Color(.3, .3, .3, 1));
			yn += 2;
		draw_texture(DataCountries.countriesImg[Data.selected.ind],Vector2(x, y-Data.selected.floatingY),
			Color(.5, .5, .5, 1) if Data.selected.team==Data.nobody else Data.Teams[Data.selected.team][1]
			);
	var i = 0
	while i<Data.entities.size():
		var ent = Data.entities[i];
		Entities.updateEntity(ent, i);
		draw_set_transform(Vector2(ent.x,ent.y), ent.angle, Vector2(1,1));
		draw_texture(entitiesSprites[ent.type], Vector2(0,0));
		i+=1
	draw_set_transform(Vector2(0,0), 0, Vector2(1,1));
	
	
	pass


