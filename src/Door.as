package
{
	import org.flixel.*;
	
	public class Door extends FlxSprite
	{
		[Embed(source="door1.png")] protected var Img1:Class;
		[Embed(source="door2.png")] protected var Img2:Class;
		[Embed(source="door3.png")] protected var Img3:Class;
		
		[Embed(source="paper.mp3")]	private	var SndPaper:Class;
		[Embed(source="deliver.mp3")]	private	var SndDeliver:Class;
		
		private var myType:uint;
		private var hasPaper:Boolean;
		private var hasEmployee:Boolean;
		private var isNormal:Boolean;
		private var myCompany;
		
		public function Door(X:Number=0, Y:Number=0, TYPE:Number = 1)
		{
			super(X, Y);
			
			myType = TYPE;
			
			switch(myType)
			{
				case (1):
					loadGraphic(Img1, true, false, 96, 80);
				break;
				case (2):
					loadGraphic(Img2, true, false, 96, 80);
				break;
				case (3):
					loadGraphic(Img3, true, false, 96, 80);
				break;
				default:
					loadGraphic(Img1, true, false, 96, 80);
			}	
		}
		
		public function makePaper():void
		{
			hasPaper = true;
			hasEmployee = false;
			isNormal = false;
			
			Globals.goal = this;
			
			this.frame = 1;
		}
		
		public function makeEmployee():void
		{
			hasPaper = false;
			hasEmployee = true;
			isNormal = false;
			
			Globals.goal = this;
			
			this.frame = 2;
		}
		
		public function setCompany(COMPANY):void
		{
			myCompany = COMPANY;
		}

		
		public function makeNormal():void
		{
			isNormal = true;
			hasPaper = false;
			hasEmployee = false;
			
			frame = 0;
		}
		
		private function processPlayer(OBJ1:FlxObject, OBJ2:FlxObject):void
		{
			if(hasPaper)
			{
				if(Globals.player.isActivating)
				{
					makeNormal();
					myCompany.makeEmployee();
					FlxG.play(SndPaper);

					Globals.player.hasPaper = true;
				}
			}
			else if(hasEmployee)
			{
				if(Globals.player.isActivating)
				{
					makeNormal();
					Globals.player.hasPaper = false;
					Globals.winNumber--;
					Globals.papersArray.shift(); 
					if(Globals.papersArray[0])
					{
						Globals.papersArray[0].makePaper();
					}
					FlxG.play(SndDeliver);
				}				
			}
		}
		
		override public function update():void
		{
			super.update();
			
			FlxG.overlap(this, Globals.player, processPlayer);
		}
	}
}