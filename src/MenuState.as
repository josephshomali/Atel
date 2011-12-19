package
{
	import com.adobe.tako.*;
	
	import org.flixel.*;
	import org.flixel.FlxState;
	
	public class MenuState extends FlxState
	{

		[Embed(source="menuBG.jpg")] protected var ImgBG:Class;
		[Embed(source="playButton.png")] protected var ImgRestartButton:Class;
		[Embed(source="instructionsButton.png")] protected var ImgInst:Class;
		
		[Embed(source="BGM2.mp3")]	private	var SndMusic:Class; 
		
		
		override public function create():void
		{
			FlxG.mouse.show();
			
			Globals.reset();
			
			var bg:FlxSprite = new FlxSprite(0, 0, ImgBG);
			add(bg);
			
			
			var restartButton:FlxButton = new FlxButton(55, 200, "", restartGame);
			restartButton.loadGraphic(ImgRestartButton);

			var instructionsButton:FlxButton = new FlxButton(55, 280, "", inst);
			instructionsButton.loadGraphic(ImgInst);
			
			
			add(instructionsButton);
			add(restartButton);	
			
			if(!Globals.isMusicPlaying)
			{
				Globals.isMusicPlaying = true;
				FlxG.playMusic(SndMusic, 0.3);
			}
						
		}
		
		public function inst():void
		{
			FlxG.switchState(new Instructions());
		}
		
		public function restartGame():void
		{
			FlxG.switchState(new PlayState);
		}
		
		override public function update():void
		{
			if ( FlxG.mouse.justReleased())
			{
				//FlxG.switchState(new PlayState());
			}
			super.update();
		}
	}
}