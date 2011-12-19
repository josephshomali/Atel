package
{
	import org.flixel.FlxState;
	import org.flixel.*;
	
	public class Instructions extends FlxState
	{
		[Embed(source="backButton.png")] protected var ImgBackButton:Class;
		[Embed(source="instructionsBG.jpg")] protected var ImgBG:Class;
		override public function create():void
		{
			FlxG.mouse.show();
			
			Globals.reset();
			
			var bg:FlxSprite = new FlxSprite(0, 0, ImgBG);
			add(bg);
			
			
			var restartButton:FlxButton = new FlxButton(55, 230, "", restartGame);
			restartButton.loadGraphic(ImgBackButton);
			
			
			add(restartButton);	
			
		}
		
		public function restartGame():void
		{
			FlxG.switchState(new MenuState());
		}
	}
}