extends Node2D


func _ready():
	pass # Replace with function body.




func _on_Button_back_pressed():
	visible = false;
	Data.layout = "gameplay"
	pass # Replace with function body.


func _on_Button_buildHouse_pressed():
	var res = Data.selected.money-Costs.cost_casa(Data.selected);
	if(res>=0):
		Data.selected.money = res;
		Data.selected.houses += 1;
	pass # Replace with function body.


func _on_Button_buildService_pressed():
	var res = Data.selected.money-Costs.cost_servico(Data.selected);
	if(res>=0):
		Data.selected.money = res;
		Data.selected.services += 1;
	pass # Replace with function body.


func _on_Button_buildCommercial_pressed():
	var res = Data.selected.money-Costs.cost_comercio(Data.selected);
	if(res>=0&&Costs.PEOPLE_FOR_COMMERCE*Data.selected.commerce<=Data.selected.population&&Costs.INDUSTRY_FOR_COMMERCE*Data.selected.industry>=(Data.selected.commerce+1)):
		Data.selected.money = res;
		Data.selected.commerce += 1;
	pass # Replace with function body.


func _on_Button_buildIndustry_pressed():
	var res = Data.selected.money-Costs.cost_industria(Data.selected);
	if(res>=0&&Costs.PEOPLE_FOR_INDUSTRY*Data.selected.industry<=Data.selected.population):
		Data.selected.money = res;
		Data.selected.industry += 1;
	pass # Replace with function body.


func _on_Button_mechandise_pressed():
	pass # Replace with function body.
