package
{
	import org.flixel.*;
	public class Globals
	{
		
		public static var player:Player;
		public static var spikesGroup:FlxGroup;	
		public static var cratesGroup:FlxGroup;
		public static var springsGroup:FlxGroup;
		public static var wins:Number = 0;
		public static var losses:Number = 0;
		public static var levelTime:Number = 0;
		public static var clicks:Number = 0;
		public static var score:Number = 0;
		public static var isGameOver:Boolean = false;
		public static var ground:FlxTilemap;
		public static var winNumber:Number;
		public static var papersArray:Array;
		public static var goal:FlxObject;
		public static var isMusicPlaying:Boolean = false;
		
		
		public static function reset():void
		{
			wins = 0;
			losses = 0;
			score = 0;
		}
		
		public static function resetLevel(CLICKS:Number):void
		{
			spikesGroup = new FlxGroup();
			cratesGroup = new FlxGroup();
			springsGroup = new FlxGroup();
			papersArray = new Array();
			levelTime = 0;
			clicks = CLICKS;
			isGameOver = false;
		}
		
		public function Globals()
		{
		}
	}
}