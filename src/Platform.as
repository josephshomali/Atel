package
{
	import org.flixel.*;
	
	public class Platform extends FlxSprite
	{
		[Embed(source="platform1.png")] protected var Img1:Class;
		[Embed(source="platform2.png")] protected var Img2:Class;
		[Embed(source="platform3.png")] protected var Img3:Class;
		
		private var myType:uint;
		private var isColliding:Boolean;
		
		public function Platform(X:Number=0, Y:Number=0, TYPE:uint = 1)
		{
			super(X, Y);
			
			myType = TYPE;
						
			switch(myType)
			{
				case (1):
					loadGraphic(Img1);
					break;
				case (2):
					loadGraphic(Img2);
					break;
				case (3):
					loadGraphic(Img3);
					break;
				default:
					loadGraphic(Img1);
			}	
			
			isColliding = false;
			
			width = 70;
			offset.x = 13;
			offset.y = 3;
			height = 17;
			
			//allowCollisions(FlxObject.UP);
			
			x += 13;
			
			this.immovable = true;
		}

		override public function update():void
		{
			super.update();
			
			//FlxG.overlap(this, Globals.player, processPlayer);
		}
	}
}