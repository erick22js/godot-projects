extends Camera2D

var oldX = 0;
var oldY = 0;
var dragging = false;
var pressing = false;

var selected = ""

func _ready():
	Data.RESOLUTION_HEIGHT = get_viewport_rect().size.y;
	Data.RESOLUTION_WIDTH = get_viewport_rect().size.x;
	pass # Replace with function body.

func _process(delta):
	updateCountryInfo({} if selected=="" else DataCountries.ADMs[selected])
	if(selected!=""):
		Data.selected = DataCountries.ADMs[selected];
	
	pass

func _input(event):
	if OS.get_name()=="Windows":
		if (!(get_viewport().get_mouse_position().y >= (Data.RESOLUTION_HEIGHT-$CountryInfo/Panel_Bottom.rect_size.y)) if $CountryInfo.visible else true):
			if event is InputEventMouseButton:
				$Label_date.text = str(get_viewport().get_mouse_position().x);
				if event.button_index==1:
					if event.pressed:
						oldX = get_viewport().get_mouse_position().x;
						oldY = get_viewport().get_mouse_position().y;
						pressing = true;
					else:
						if !dragging && Data.layout=="gameplay":
							#print("click")
							_click(get_viewport().get_mouse_position());
						pressing = false;
						dragging = false;
			if event is InputEventMouseMotion:
				if pressing:
					dragging = true;
				if dragging:
					var pos = get_viewport().get_mouse_position();
					if Data.layout=="gameplay":
						#print("drag")
						position.x -= pos.x-oldX;
						position.x = Data.RESOLUTION_WIDTH*.5 if position.x<Data.RESOLUTION_WIDTH*.5 else (3508-Data.RESOLUTION_WIDTH*.5 if position.x > 3508-Data.RESOLUTION_WIDTH*.5 else position.x);
						position.y -= pos.y-oldY;
						position.y = Data.RESOLUTION_HEIGHT*.5 if position.y<Data.RESOLUTION_HEIGHT*.5 else (2480-Data.RESOLUTION_HEIGHT*.5 if position.y > 2480-Data.RESOLUTION_HEIGHT*.5 else position.y);
					oldX = pos.x;
					oldY = pos.y;
		else:
			pressing = false;
			dragging = false;
		#print(get_viewport().get_mouse_position().x);
	if OS.get_name()=="Android":
		if event is InputEventScreenTouch:
			$Label_date.text = str(event.position.x);
			if (!(event.position.y >= (Data.RESOLUTION_HEIGHT-$CountryInfo/Panel_Bottom.rect_size.y)) if $CountryInfo.visible else true):
				if event.pressed:
					oldX = event.position.x;
					oldY = event.position.y;
					pressing = true;
				else:
					if !dragging && Data.layout=="gameplay":
						_click(event.position);
					pressing = false;
					dragging = false;
			if event is InputEventScreenDrag:
				if pressing:
					dragging = true;
				if dragging:
					var pos = event.position;
					if Data.layout=="gameplay":
						#print("drag")
						position.x -= pos.x-oldX;
						position.x = Data.RESOLUTION_WIDTH*.5 if position.x<Data.RESOLUTION_WIDTH*.5 else (3508-Data.RESOLUTION_WIDTH*.5 if position.x > 3508-Data.RESOLUTION_WIDTH*.5 else position.x);
						position.y -= pos.y-oldY;
						position.y = Data.RESOLUTION_HEIGHT*.5 if position.y<Data.RESOLUTION_HEIGHT*.5 else (2480-Data.RESOLUTION_HEIGHT*.5 if position.y > 2480-Data.RESOLUTION_HEIGHT*.5 else position.y);
					oldX = pos.x;
					oldY = pos.y;
		else:
			pressing = false;
			dragging = false;
	pass

func _click(point):
	if(selected!=""):
		DataCountries.ADMs[selected].selected = false;
		$CountryInfo.visible = false;
	#Pick country
	var px = position.x+point.x-get_viewport_rect().size.x*.5;
	var py = position.y+point.y-get_viewport_rect().size.y*.5;
	var oldSelected = selected;
	for c in DataCountries.countriesImg:
		var x = px-DataCountries.countries[c].x;
		var y = py-DataCountries.countries[c].y;
		var img = DataCountries.countriesImg[c].get_data();
		if(x<0||y<0||x>=img.get_width()||y>=img.get_height()):
			continue
		img.lock();
		if(img.get_pixel(int(x),int(y)).r == 1):
			DataCountries.ADMs[c].selected = true;
			selected = c;
			$CountryInfo.visible = true;
			break;
	if(oldSelected==selected&&selected!=""):
		DataCountries.ADMs[selected].selected = false;
		selected = "";
		$CountryInfo.visible = false;
	#selected = 
	#print("tapped!");
	pass

func updateCountryInfo(country):
	#$Label_date.text = str(Data.day)+" / "+str(Data.mounth)+" / "+str(Data.year);
	if(selected!=""):
		#Country info layout
		$CountryInfo/Label_countryName.text = country.name;
		$CountryInfo/Label_population.text = "População: "+str(country.population);
		$CountryInfo/Label_money.text = "Economia: "+Costs.format_money(country.money);
		#Country manager layout
		$CountryManager/Label_house.text = "Casas: "+str(country.houses)+"\n$ "+str(Costs.cost_casa(country));
		$CountryManager/Label_commerces.text = "Comércios: "+str(country.commerce)+"\n$ "+str(Costs.cost_comercio(country));
		$CountryManager/Label_service.text = "Serviços: "+str(country.services)+"\n$ "+str(Costs.cost_servico(country));
		$CountryManager/Label_industry.text = "Indústrias: "+str(country.industry)+"\n$ "+str(Costs.cost_industria(country));
		$CountryManager/Label_money.text = Costs.format_money(country.money);
		$CountryManager/Label_rent.text = "$ "+str(Costs.gain_country(country));
		$CountryManager/Label_rent.modulate = Color(0, .8, 0, 1) if Costs.gain_country(country)>0 else Color(255, 0, 0, 1);
		$CountryManager/PopulationSatisfation.value = country.satisfaction;
	pass


func _on_Button_manager_pressed():
	$CountryManager.visible = true;
	Data.layout = "country_manager"
	pass # Replace with function body.
