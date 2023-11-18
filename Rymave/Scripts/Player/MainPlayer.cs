using Godot;
using System;


public class MainPlayer : Polygon2D{
    
    //Player attributes
    [Export]
    public float attr_speed = 1.0f;
    
    //Player motion properties
    public float motion_multiplier = 1.0f;
    public Vector2 motion_vector = new Vector2(0, 0);
    
    //Nodes path
    [Export]
    Godot.NodePath _nodepath_sword_obj;
    Godot.Node2D sword_obj;
    
    // Called when the node enters the scene tree for the first time.
    public override void _Ready(){
        if(_nodepath_sword_obj==null){
            GD.Print("Not loaded sword object");
        }else{
            sword_obj = (Node2D)GetNode(_nodepath_sword_obj);
            GD.Print("Has been loaded sword object");
        }
    }
    
    public override void _Input(InputEvent i_ev){
        //Default game controls
        if(i_ev is InputEventKey i_key){
            switch((KeyList)i_key.Scancode){
                case KeyList.W:
                    RyGameInput.MOVE_PLAYER_UP = (byte)(i_key.Pressed?1:0);
                break;
                case KeyList.S:
                    RyGameInput.MOVE_PLAYER_DOWN = (byte)(i_key.Pressed?1:0);
                break;
                case KeyList.A:
                    RyGameInput.MOVE_PLAYER_LEFT = (byte)(i_key.Pressed?1:0);
                break;
                case KeyList.D:
                    RyGameInput.MOVE_PLAYER_RIGHT = (byte)(i_key.Pressed?1:0);
                break;
                case KeyList.Space:
                    RyGameInput.MOVE_PLAYER_ATACK = (byte)(i_key.Pressed?1:0);
                break;
            }
        }
    }
    
    // Called every frame. 'delta' is the elapsed time since the previous frame.
    public override void _Process(float delta){
        //Moviment the player
        motion_vector.x = RyGameInput.MOVE_PLAYER_RIGHT-RyGameInput.MOVE_PLAYER_LEFT;
        motion_vector.y = RyGameInput.MOVE_PLAYER_DOWN-RyGameInput.MOVE_PLAYER_UP;
        motion_vector *= motion_multiplier*attr_speed;
        this.Position += motion_vector;
    }
}
