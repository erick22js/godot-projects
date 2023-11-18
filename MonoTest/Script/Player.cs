using Godot;
using System;

class listKeys{
	
};

public class Player : Polygon2D{
	// Declare member variables here. Examples:
	// private int a = 2;
	// private string b = "text";
	struct keyAttrib{
		uint code;
		bool press_s1;
		bool press_s2;
	};
	
	
	// Called when the node enters the scene tree for the first time.
	public override void _Ready(){
		Array keys = new Array();
	}

	public override void _Input(InputEvent ev){
		
		if(ev is InputEventKey){
			InputEventKey kev = (InputEventKey)ev;
			
			switch(kev.Scancode){
				case (uint)KeyList.W:{
					
				}
				break;
			}
		}
	}
	
	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(float delta){
		
	}
}
