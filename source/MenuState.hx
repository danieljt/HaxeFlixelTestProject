package;

import flixel.FlxState;
import flixel.ui.FlxButton;
import flixel.FlxG;

class MenuState extends FlxState
{
    var _btnPlay:FlxButton;
    var _play:Bool = false;

	override public function create():Void
	{
		super.create();
	}

	override public function update(elapsed:Float):Void
	{   
        // Add play button that can be clicked with the mouse to
        // start playing the game
        _btnPlay = new FlxButton(0,0,"Play", clickPlay);
        _btnPlay.screenCenter();
        add(_btnPlay);

        // Add so the player can press space or enter to
        // start the game
        _play = FlxG.keys.anyPressed([SPACE, ENTER]);
        startGame();
		super.update(elapsed);
	}

    // If button is pressed with the mouse, start the game
    function clickPlay():Void
    {
        FlxG.switchState(new PlayState());
    }

    // Function checks if buttons are pressed for starting
    // the game
    function startGame():Void{
        if (_play){
            clickPlay();
        }
    }
}