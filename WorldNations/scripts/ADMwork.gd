extends Node

#
# Casas: aumentam a população e pagam impostos
# Comercial: para pagarem impostos, precisam de uma certa população
# Serviços: exigem gastos, mas satisfazem a população
# Industriais: realizam produções, mas, para funcionarem, precisa-se de população 
# 

func updateCountry(country):
	#Grow population
	if country.population < country.houses*Costs.PEOPLE_FOR_HOUSES:
		country.population += Costs.gain_population(country);
	#Render money
	country.money += Costs.gain_country(country);
	#Update population satisfaction
	country.satisfaction = Costs.gain_satisfaction(country);
	if country.team > 0:
		botHandling(country);
	pass;

func botHandling(country):
	Ai.moves = 2;
	Ai.decide(country);
	pass;
