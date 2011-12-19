package
{
	import org.flixel.*;
	import org.flixel.FlxState;
	import com.adobe.tako.*;
	
	public class WinState extends FlxState
	{
		[Embed(source="backButton.png")] protected var ImgBackButton:Class;
		[Embed(source="winBG.jpg")] protected var ImgBG:Class;
		
		protected var takoBridge:GameTakoBridge; 

		
		override public function create():void
		{
			var bg:FlxSprite = new FlxSprite(0, 0, ImgBG);
			add(bg);
			
			var restartButton:FlxButton = new FlxButton(60, 490, "", restartGame);
			restartButton.loadGraphic(ImgBackButton);
			
			add(restartButton);	
			
			takoBridge = new GameTakoBridge();
			
			takoBridge.post2Facebook(new Array("0000000000000031", 100));


		}
		
		private function restartGame():void
		{
			FlxG.switchState(new MenuState());
		}
	}
}