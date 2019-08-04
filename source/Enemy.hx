package;
import flixel.math.FlxVector;
import flixel.math.FlxVelocity;
import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.FlxObject;
import flixel.FlxSprite;

class Enemy extends FlxSprite{
    var _brain:FSM;
    var _idleTmr:Float;
    var _moveDir:Float;
    public var speed = 140;
    public var vision:FlxVector;
    public var etype(default, null):Int;
    public var seesPlayer:Bool = false;
    public var playerPos(default, null):FlxPoint;

    public function new(X:Float=0, Y:Float=0, Etype:Int){
        super(X,Y);
        etype = Etype;
        loadGraphic("assets/images/enemy-" + etype + ".png", true, 16, 16);
        setFacingFlip(FlxObject.LEFT, false, false);
        setFacingFlip(FlxObject.RIGHT, true, false);
        animation.add("d", [0, 1, 0, 1], 0, false);
        animation.add("u", [4, 5, 4, 5], 0, false);
        animation.add("s", [2, 3, 2, 3], 0, false);
        drag.x = drag.y = 10;
        width = 6;
        height = 12;
        offset.x = 0;
        offset.y = 0;
        _brain = new FSM(idle);
        vision = new FlxVector(36,36);
        _idleTmr = 0;
        playerPos = FlxPoint.get();
    }
    /**
    Function for when an enemy is in an idle state. If the player comes within
    the enemy line of sight, the enemy will chase the player. If not, the enemy will
    move in random directions at random time intervals.
    **/
    public function idle():Void{
        if(seesPlayer){
            _brain.activeState = chase;
        }
        else if (_idleTmr <= 0){
            if(FlxG.random.bool(1)){
                _moveDir = -1;
                velocity.x = velocity.y = 0;
            }
            else{
                _moveDir = FlxG.random.int(0,8)*45;
                velocity.set(speed*0.5, 0);
                velocity.rotate(FlxPoint.weak(), _moveDir);
            }
            _idleTmr = FlxG.random.int(1, 4);
        }
        else{
            _idleTmr -= FlxG.elapsed;
        }
    }

    /**
    Function for when the enemy is in the chase state. The enemy will move towards the 
    players location. If the player goes out of the enemies line of sight, the enemy will
    revert to the idle state. 
    **/
    public function chase():Void{
        if(!seesPlayer){
            _brain.activeState = idle;
        }
        else{
            FlxVelocity.moveTowardsPoint(this, playerPos, Std.int(speed));
        }
    }

    /**
    Apply enemy movement, facing and animation frames. 
    **/
    override public function draw():Void{
        if((velocity.x !=0 || velocity.y != 0) && touching == FlxObject.NONE){
            if(Math.abs(velocity.x) > Math.abs(velocity.y)){
                if(velocity.x < 0){
                    facing = FlxObject.LEFT;
                }
                else{
                    facing = FlxObject.RIGHT;
                }
            }
            else{
                if(velocity.y < 0){
                    facing = FlxObject.UP;
                }
                else{
                    facing = FlxObject.DOWN;
                }
            }

            switch(facing){
                case FlxObject.LEFT, FlxObject.RIGHT:
                animation.play("s");
                case FlxObject.UP:
                animation.play("u");
                case FlxObject.DOWN:
                animation.play("d");
            }
        }
        super.draw();
    }

    override public function update(elapsed:Float):Void{
        _brain.update();
        super.update(elapsed);
    }
}