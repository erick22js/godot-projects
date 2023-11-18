extends Node

#
#	CPU gameplay
#	focus: grow_city => atentar para o crescimento da cidade e para a satisfação do povo
#	           causas: ambição populacional, aleatório
#	           consequencias: leva a escassez econômica, têndencia a focar na econômia
#              continuidade: pode ser interrompido, não é obrigatório
#	       manage_economy => construir comércios e indústrias
#              causas: baixa econômia para a situação qual se encontra, mas pode ser aleatória
#              consequencias: impossibiliade de continuar construindo comércios, ou/e indústrias, têndencia a focar em relações de amizades
#              continuidade: pode ser interrompido, desde que, não haja forma como construir, ou seja interrompido por evento aleatório de maior prioridade
#	       global_seiling => exportações de produtos ao mercado externo
#	       friendly_relation => dedicação ao cultivo de relações entre impérios
#	       war => dedicação á guerra contra inimigos, ou conquista de territórios
#	           causas: provocação por algum outro país, ou situação ecônomica grave, ou pode ser um evento aleatório, se for um país hostil
#	           consequência: degeneração do oponente, que se destruído, oferece fonte de saque para o país, e pode servir de colônia para sua união
#	           continuidade: 
#

var focus = {
	"grow_city":{
		"priority":2
		,"required":false
	},"manage_economy":{
		"priority":3
		,"required":true
	}
}

var actual_country = {};
var moves = 2;

func decide(country):
	actual_country = country;
	if focus[actual_country.focus].required||country.needFocus:
		pickFunction(actual_country.focus);
		pass
	else:
		if actual_country.commerce*Costs.PEOPLE_FOR_COMMERCE*.8<actual_country.population:
			pickFunction("manage_economy");
		var choice = Util.random(0,1);
		if choice<.6:
			pickFunction(country.focus);
			pass
		else:
			randomDecision();
	pass

func randomDecision():
	var choose = int(Util.random(0, 2));
	pickFunction(choose);

func pickFunction(index): #index can be a string or integer
	moves -= 1;
	if moves<=0: return;
	if typeof(index)==TYPE_STRING:
		match index:
			"grow_city":
				grow_city();
				pass
			"manage_economy":
				manage_economy();
				pass
		pass
	else:
		match index:
			0:
				grow_city();
				pass
			1:
				manage_economy();
				pass
		pass
	pass

func grow_city():
	print("grow_city");
	var choice = Util.random(0,1)*(Util.random(.75,2.5) if (Costs.gain_satisfaction(actual_country)<=Costs.MIN_ALLOW_POPULATION_INSATISFATION&&actual_country.population>=Costs.MIN_ALLOW_QPOPULATION_NO_SERVICE) else 1);
	var sucessfull = null;
	if choice<.6:
		var sucessfull2 = null;
		if(Costs.gain_satisfaction(actual_country)<=Costs.PANIC_POPULATION):
			if goodIdeaBuyService():
				sucessfull2 = buy_service();
		if(sucessfull2==null): sucessfull = buy_house();
		else: sucessfull = sucessfull2;
		if actual_country.population>actual_country.services*Costs.SERVICES_COVER_FOR_EACH_ONE+Costs.SERVICES_COVER_FOR_EACH_ONE*actual_country.commercialPlan.invest.houses:
			actual_country.needFocus = false;
		pass
	else:
		print(Costs.gain_country(actual_country)-Costs.LESS_SERVICE);
		if goodIdeaBuyService():
			sucessfull = buy_service();
	if sucessfull=="money":
		randomDecision();

func manage_economy():
	print("manage_economy");
	var choice = Util.random(0,1)*(Util.random(.75,2.5) if ((Costs.INDUSTRY_FOR_COMMERCE*actual_country.industry)/(actual_country.commerce+.01)>.8) else 1);
	var sucessfull = null;
	if choice<.8:
		sucessfull = buy_commerce();
		print(sucessfull)
		if sucessfull=="population":
			actual_country.focus = "grow_city";
			actual_country.needFocus = true; 
			decide(actual_country);
			return;
		pass
	else:
		print(Costs.gain_country(actual_country)-Costs.LESS_SERVICE);
		if (goodIdeaBuyIndustry()):
			sucessfull = buy_industry();
	if sucessfull=="money":
		#randomDecision();
		return;
	elif sucessfull=="population":
		actual_country.focus = "grow_city";
		decide(actual_country);
		return;
	pass

#BUY ISSUES
func returnBuyIssue(moneyC, populationC, commerceC, industryC):
	return "money" if moneyC else "population" if populationC else "commerce" if commerceC else "industry" if industryC else null;
func goodIdeaBuyService():
	if (Costs.gain_country(actual_country)-Costs.LESS_SERVICE)<=actual_country.houses*actual_country.commercialPlan.retrieveMoney.services:
		actual_country.focus = "manage_economy";
		decide(actual_country);
		return false;
	return true;
func goodIdeaBuyIndustry():
	if (Costs.gain_country(actual_country)-Costs.LESS_SERVICE)<=actual_country.commerce*actual_country.commercialPlan.retrieveMoney.industry:
		decide(actual_country);
		return false;
	return true;
	

#BUY SECTION -> then return sucessfull about the shop

func buy_house():
	var res = actual_country.money-Costs.cost_casa(actual_country);
	print("Building house, issue: "+str(returnBuyIssue(res<=0, false, false, false)))
	if(res>=0):
		actual_country.money = res;
		actual_country.houses += 1;
	return returnBuyIssue(res<=0, false, false, false);
func buy_service():
	var res = actual_country.money-Costs.cost_servico(actual_country);
	print("Building service, issue: "+str(returnBuyIssue(res<=0, false, false, false)))
	if(res>=0):
		actual_country.money = res;
		actual_country.services += 1;
	return returnBuyIssue(res<=0, false, false, false);
func buy_commerce():
	var res = actual_country.money-Costs.cost_comercio(actual_country);
	var issue = returnBuyIssue(res<=0, !(Costs.PEOPLE_FOR_COMMERCE*actual_country.commerce<=actual_country.population), false, !(Costs.INDUSTRY_FOR_COMMERCE*actual_country.industry>=(actual_country.commerce)));
	print("building commerce, issue: "+str(issue))
	if(
		res>=0&&
		Costs.PEOPLE_FOR_COMMERCE*actual_country.commerce<=actual_country.population&&
		Costs.INDUSTRY_FOR_COMMERCE*actual_country.industry>=(actual_country.commerce+1)):
		actual_country.money = res;
		actual_country.commerce += 1;
	return issue;
func buy_industry():
	var res = actual_country.money-Costs.cost_industria(actual_country);
	var issue = returnBuyIssue(res<=0, !(Costs.PEOPLE_FOR_INDUSTRY*actual_country.industry<=actual_country.population), false, false);
	print("building industry, issue: "+str(issue))
	if(
		res>=0&&
		Costs.PEOPLE_FOR_INDUSTRY*actual_country.industry<=actual_country.population):
		actual_country.money = res;
		actual_country.industry += 1;
	return issue;
