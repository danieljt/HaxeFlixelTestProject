import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.FlxSprite;

class Orb extends FlxSprite{
    public function new(X:Float=0, Y:Float=0){
        super(X, Y);
        loadGraphic(AssetPaths.orb_green_yellow__png, false, 8, 8);
    }
    /**
    Adds fancy animation for collecting orbs.
    **/
    override public function kill():Void{
        alive = false;
        FlxTween.tween(this, {alpha: 0, y: y - 16}, .33, {ease:FlxEase.circOut, onComplete: finishKill});
    }

    function finishKill(_):Void{
        exists = false;
    }
}
