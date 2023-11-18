extends Node2D


var present_type = "";

func _ready():
	pass

func _process(delta):
	
	pass

func _on_Button_send_pressed():
	self.visible = true;
	Data.layout = "give_present";
	pass # Replace with function body.


func _on_Button_confirm_send_pressed():
	self.visible = false;
	Data.layout = "gameplay";
	Entities.addEntitie("ship",{},500,500);
	pass # Replace with function body.
