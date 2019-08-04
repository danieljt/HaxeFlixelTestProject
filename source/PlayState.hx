package;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxObject;
import flixel.addons.editors.ogmo.FlxOgmoLoader;
import flixel.tile.FlxTilemap;
import flixel.FlxState;
import flixel.FlxG;

class PlayState extends FlxState
{
	var _player:Player;
	var _map:FlxOgmoLoader;
	var _mWalls:FlxTilemap;
	var _groupEnemies:FlxTypedGroup<Enemy>;
	var _groupOrbs:FlxTypedGroup<Orb>;

	override public function create():Void
	{

		 //Create world, tiles and background
		_map = new FlxOgmoLoader(AssetPaths.custom_room__oel);
		_mWalls = _map.loadTilemap(AssetPaths.wall001__png,16,16,"walls");
		_mWalls.follow();
		_mWalls.setTileProperties(1, FlxObject.NONE);
		_mWalls.setTileProperties(2, FlxObject.ANY);
		add(_mWalls);

		// Create pick ups
		_groupOrbs = new FlxTypedGroup<Orb>();
		add(_groupOrbs);

		// Create enemies
		_groupEnemies = new FlxTypedGroup<Enemy>();
		add(_groupEnemies);

		// Create player 
		_player = new Player();

		// Load all objects, tiles and entities.
		_map.loadEntities(placeEntities, "entities");

		// Add player in the end to prohibit movement before
		// map is loaded. Prevents bugs and other creepy behavior
		add(_player);

		// Apply camera to move after player with 1 pixel 
		FlxG.camera.follow(_player, TOPDOWN, 1);
		super.create();
	}

	/**
	Read entities from xml file created in ogmo and apply to game
	world. 
	**/
	
	function placeEntities(entityName:String, entityData:Xml):Void
	{
		var x:Int = Std.parseInt(entityData.get("x"));
		var y:Int = Std.parseInt(entityData.get("y"));

		if (entityName == "player"){
			_player.x = x;
			_player.y = y;
		}
		else if (entityName == "orb"){
			_groupOrbs.add(new Orb(x + 4, y + 4));
		}

		else if(entityName == "enemy"){
			_groupEnemies.add(new Enemy(x, y, Std.parseInt(entityData.get("etype"))));
		}
	}
	
	/**
	Function for when the player touches an orb
	**/
	function playerTouchOrb(player:Player, orb:Orb):Void
	{
		if(player.alive && player.exists && orb.alive && orb.exists){
			orb.kill();
		}
	}

	/**
	Function for when an enemy touches the player
	**/
	function enemyTouchPlayer(enemy:Enemy, player:Player):Void{
		if(player.alive && player.exists && enemy.alive && enemy.exists){

		}
	}
	
	/**
	Function checks if the enemy can see the player
	**/
	function checkEnemyVision(enemy:Enemy):Void{
		if( _mWalls.ray(enemy.getMidpoint(), _player.getMidpoint()) && (enemy.getMidpoint().distanceTo(_player.getMidpoint()) <= (enemy.vision.length))){
			enemy.seesPlayer = true;
			enemy.playerPos.copyFrom(_player.getMidpoint());
		}
		else{
			enemy.seesPlayer = false;
		}
	}
	
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		FlxG.collide(_player, _mWalls);
		FlxG.overlap(_player, _groupOrbs, playerTouchOrb);
		FlxG.collide(_groupEnemies, _mWalls);
		_groupEnemies.forEachAlive(checkEnemyVision);
	}
}
