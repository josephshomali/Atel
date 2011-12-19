package
{
	import org.flixel.*;
	import org.flixel.FlxButton;
	import org.flixel.FlxGroup;
	
	public class GameOverScreen extends FlxGroup
	{
		public var restartButton:FlxButton;
		public var menuButton:FlxButton;
		
		public function GameOverScreen(MaxSize:uint=0)
		{
			super(MaxSize);
			
			restartButton = new FlxButton(100, 100, "RESTART", restartGame);
			menuButton = new FlxButton(200, 200, "MENU", gotoMenu);
			
			add(restartButton);
			add(menuButton);
		}
		
		public function restartGame():void
		{
			FlxG.resetState();
		}
		
		public function gotoMenu():void
		{
			FlxG.switchState(new MenuState());	
		}
	}
}