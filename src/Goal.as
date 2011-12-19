package
{
	import org.flixel.*;
	import org.flixel.FlxSprite;
	
	public class Goal extends FlxSprite
	{
		private var player:Player;
		private var nextLevel:Class;
		
		[Embed(source="goal.png")] protected var Img:Class;
		public function Goal(X:Number, Y:Number, playstate:Class)
		{
			super(X, Y, Img);
			
			acceleration.y = 420;
			
			nextLevel = playstate;
		}
		
		
		private function processPlayer(Object1:FlxObject, Object2:FlxObject):void
		{
			Globals.score += Globals.clicks * 100;
			FlxG.switchState(new nextLevel());
		}
		
		override public function update():void
		{
			super.update();
			
			FlxG.overlap(this, Globals.player, processPlayer);
			//FlxG.overlap(r, r,
			
		}
	}
}