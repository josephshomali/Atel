package
{
	import org.flixel.*;
	import org.flixel.FlxSprite;
	
	public class Enemy extends FlxSprite
	{
		[Embed(source="wasta.png")] protected var Img:Class;
		
		private var point1:Number;
		private var point2:Number;
		private var direction:String;
		private var isMoving:Boolean;
		private var isFighting:Boolean;
		public var fights:Number;
		public var isAlive:Boolean;
		public var maxFights:Number;
		
		public function Enemy(X:Number=0, Y:Number=0, FIGHTS:uint = 3)
		{
			super(X, Y);
						
			this.loadGraphic(Img, true, false, 33, 48);
			
			addAnimation("walk", [1, 2], 5, true);
			addAnimation("idle", [0], 0, false);
			
			isAlive = true;
			
			maxFights = FIGHTS;
			fights = FIGHTS;
			
			isFighting = false;
			
			x += Math.random() * 64;
			
			isMoving = true;
			point1 = X;
			point2 = X + 65;
			direction = "RIGHT";
			
			acceleration.y = 500;
		}
		
		public function damage():void
		{
			fights--;
			
			if(fights <= 0)
			{
				Globals.player.win();
				defeat();
			}
		}
		
		public function win():void
		{

			//fights++;
			Globals.player.pushMe();
			isFighting = false;
			
			fights = maxFights;
		}
		
		public function defeat():void
		{
			if(!isAlive)
			{
				return;
			}
			isAlive = false;
			angle = 180;
		}
		
		private function processPlayer(OBJ1:FlxObject, OBJ2:FlxObject):void
		{
			if(Globals.player.isPushed)
			{
				return;
			}
			
			if(Globals.player.velocity.y <= 20 && Globals.player.velocity.y >= -20)
			{
				isFighting = true;
				Globals.player.fight(this);
				play("idle");
			}
		}
		
		override public function update():void
		{
			visible = true;
			if(!isAlive)
			{
				this.solid = false;
				acceleration.y = 500;
								
				super.update();

				if(y > 4000)
					kill();

				return;
			}
			
			if(!isFighting)
			{

				if(isTouching(FlxObject.RIGHT))
				{
					direction = "LEFT";
				}
				else if(isTouching(FlxObject.LEFT))
				{
					direction = "RIGHT";
				}
				
				angle = 0;
				if(isMoving)
				{
					play("walk");
				}
				
				if(direction == "RIGHT")
				{
					facing = RIGHT;
					
					this.x ++;
					
					if(x >= point2)
					{
						direction = "LEFT";
					}
				}
				else
				{
					this.facing = LEFT;
					
					this.x --;
					
					if(x <= point1)
					{
						direction = "RIGHT";
					}
				}
			}
			else
			{
				//angle = 180;
				visible = false;
			}
			
			isFighting = false;
			
			FlxG.overlap(this, Globals.player, processPlayer);
			
			super.update();
		}
	}
}