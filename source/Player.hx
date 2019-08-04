package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.FlxObject;

class Player extends FlxSprite{
    public var speed:Float = 200;
    public var mA:Float = 0;

    public function new(?X:Float=0, ?Y:Float=0){
        super(X, Y);

        // Load spritesheet and set sprite facings for performance
        loadGraphic(AssetPaths.ball_multigrid__png, true, 16, 16);
        setFacingFlip(FlxObject.LEFT, false, false);
        setFacingFlip(FlxObject.RIGHT, true, false);

        // Set animation to movement
        animation.add("lr", [2,3,2,3], 6, false);
        animation.add("u", [6,7,6,7], 6, false);
        animation.add("d", [0,1,0,1], 6, false);
        drag.x = drag.y = 1600;
        setSize(16,16);
    }

    /*
    Function is called every frame
    */
    override function update(elapsed:Float) {
        movement();
        super.update(elapsed);
    }

    /**
    Define all movement of player
    **/
    function movement():Void{
        // Define key presses and movements in up, down
        // right and left
        var _up:Bool = false;
        var _down:Bool = false;
        var _left:Bool = false;
        var _right:Bool = false;

        // Add key presses to list and assign to
        // boolean values
        _up = FlxG.keys.anyPressed([UP,W]);
        _down = FlxG.keys.anyPressed([DOWN, S]);
        _left = FlxG.keys.anyPressed([LEFT, A]);
        _right = FlxG.keys.anyPressed([RIGHT, D]);

        // If up and down are pressed simultaneously,
        // cancel out movement
        if (_up && _down) {
            _up = _down = false;
        }

        // If left and right movement keys are pressed
        // simutaneously, cancel out movement
        if (_left && _right) {
            _left = _right = false;
        }

        // If any directonal keys are pressed, add
        // movement to player
        if(_up || _down || _left || _right){

            if(_up){
                mA = -90;
                facing = FlxObject.UP;
                if(_left){
                    mA -= 45;
                    facing = FlxObject.LEFT;
                }
                else if (_right){
                    mA += 45;
                    facing = FlxObject.RIGHT;
                }
            }

            else if (_down){
                mA = 90;
                facing = FlxObject.DOWN;
                if(_left){
                    mA += 45;
                    facing = FlxObject.LEFT;
                }
                else if(_right){
                    mA -= 45;
                    facing = FlxObject.RIGHT;
                }
            }

            else if(_left){
                mA = 180;
                facing = FlxObject.LEFT;
                if(_up){
                    mA += 45;
                    facing = FlxObject.UP;
                }
                else if(_down){
                    mA -= 45;
                    facing = FlxObject.DOWN;
                }
            }

            else if(_right){
                mA = 0;
                facing = FlxObject.RIGHT;
                if(_up){
                    mA -= 45;
                    facing = FlxObject.UP;
                }
                else if(_down){
                    mA += 45;
                    facing = FlxObject.DOWN;
                }
            }

            // Use triangle rules for correct diagonal movement
            velocity.set(speed, 0);
            velocity.rotate(FlxPoint.weak(0,0), mA);
        }

        // Animate as long as speed != 0 and as long as not touching 
        // another object
        if((velocity.x != 0 || velocity.y != 0) && touching == FlxObject.NONE){
            switch (facing){
                case FlxObject.LEFT, FlxObject.RIGHT:
                animation.play("lr");
                case FlxObject.UP:
                animation.play("u");
                case FlxObject.DOWN:
                animation.play("d");
            }
        }
    }

    function Beingpushed(){
        
    }
}