extends Node

#CASA
const BASE_CASA = 50;
const MULT_CASA = 10;
#SERVIÇO
const BASE_SERVICOS = 200;
const MULT_SERVICOS = 100;
#COMERCIAL
const BASE_COMERCIAL = 100;
const MULT_COMERCIAL = 50;
#INDUSTRIA
const BASE_INDUSTRIA = 500;
const MULT_INDUSTRIA = 250;

#Custos e ganhos
const GAIN_HOUSES = .1;
const GAIN_COMMERCE = 2;
const LESS_SERVICE = 1.2;
const LESS_INDUSTRY = 5;
#PEOPLE_FOR_COMMERCE/PEOPLE_FOR_HOUSES
#Regras de jogo
const PEOPLE_FOR_COMMERCE = 8;
const INDUSTRY_FOR_COMMERCE = 20;
const PEOPLE_FOR_INDUSTRY = 0;
const PEOPLE_FOR_HOUSES = 4;
const SERVICES_COVER_FOR_EACH_ONE = 32;
const MIN_ALLOW_QPOPULATION_NO_SERVICE = 50;
const MAX_ALLOW_QPOPULATION_NO_SERVICE = 100;
const MIN_ALLOW_POPULATION_INSATISFATION = .6;
const PANIC_POPULATION = .45;

func cost_casa(country):
	return country.houses*MULT_CASA+BASE_CASA;
func cost_servico(country):
	return country.services*MULT_SERVICOS+BASE_SERVICOS;
func cost_comercio(country):
	return country.commerce*MULT_COMERCIAL+BASE_COMERCIAL;
func cost_industria(country):
	return country.industry*MULT_INDUSTRIA+BASE_INDUSTRIA;

func gain_country(country):
	var gainHouses = country.houses * GAIN_HOUSES;
	var gainCommerce = country.commerce * GAIN_COMMERCE;
	var lessService = country.services * LESS_SERVICE;
	var lessIndustry = country.industry * LESS_INDUSTRY;
	return gainHouses+gainCommerce-lessService-lessIndustry;
func gain_population(country):
	var quanti = country.population;
	var maximus = country.houses*Costs.PEOPLE_FOR_HOUSES;
	return stepify((maximus-quanti+(int(Util.random(0,3)*2-1)))*.1,1);
func gain_satisfaction(country):
	if country.population==0: return 0
	var gain = Util.pow_progress((SERVICES_COVER_FOR_EACH_ONE*country.services)/(country.population+.0),1);
	return gain;

func format_money(q):
	return "$ "+str("%.2f" % q);
