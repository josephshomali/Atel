package
{
	import org.flixel.*;
	import org.flixel.FlxSprite;
	
	public class Player extends FlxSprite
	{
		[Embed(source="player.png")] protected var Img:Class;
		[Embed(source="jump.mp3")]	private	var SndJump:Class;
		[Embed(source="fight.mp3")]	private	var SndFight:Class;
		[Embed(source="win.mp3")]	private	var SndWin:Class;
		[Embed(source="lose.mp3")]	private	var SndLose:Class;
		
		protected var _jumpPower:int;
		private var _myFrame:Number;
		private var isDead:Boolean;
		public var hasPaper:Boolean = false;
		public var isActivating:Boolean;
		private var enemy:Enemy;
		public var isFighting:Boolean;
		public var sequence:Array;
		public var currentArrow:uint;
		private var activeSequence:Boolean;
		public var isPushed:Boolean = false;
		private var pushTimer:int = 30;
		private var pushTimerMax:uint = 30;
		private var maxTimer:int = 70;
		private var timer:int = 70;
		public var isChanging:Boolean = false;
		
		public function Player(X:Number=0, Y:Number=0)
		{
			super(X,Y);
			loadGraphic(Img,true,true,37, 53);
			
			isChanging = false;
			
			this.antialiasing = true;
			
			isPushed = false;
			
			sequence = new Array("UP", "DOWN", "LEFT", "RIGHT");
			
			isFighting = false;
			hasPaper = false;
			
			activeSequence = false;
			
			//bounding box tweaks
			width = 15;
			height = 45;
			offset.x = 11;
			offset.y = 8;
			
			//offset.y = 1;
			
			isDead = false;
			
			isActivating = false;
			
			addAnimation("idle",[0],0, false); 
			addAnimation("walk",[1,2], 5, true);
			addAnimation("idlePaper", [4], 0, false);
			addAnimation("walkPaper",[5, 6],5, true);
			addAnimation("jump", [3], 0, false);
			addAnimation("jumpPaper",[7], 0, false);
			
			//FlxG.co
			
			this.allowCollisions = FlxObject.DOWN;
			
			//basic player physics
			var runSpeed:uint = 150;
			drag.x = runSpeed*8;
			acceleration.y = 600;
			_jumpPower = 350;
			maxVelocity.x = runSpeed;
			maxVelocity.y = _jumpPower * 1.4;
			angularDrag = 20;
			
		}
		
		public function fight(ENEMY:Enemy):void
		{
			if(isFighting)
			{
				return;
			}
			enemy = ENEMY;
			isFighting = true;
		}
		
		public function win():void
		{
			enemy = null;
			isFighting = false;
			FlxG.play(SndWin);
		}
		
		public function die():void
		{
			if(isDead) return
			
			isDead = true;
			Globals.losses += 1;
			Globals.isGameOver = true;
		}
		
		public function doubleJump():void
		{
			velocity.y = -(10 * _jumpPower);
		}
		
		private function createSequence():void
		{
			if(activeSequence)
				return;
			timer = maxTimer;
			isChanging = true;
			currentArrow = Math.abs(Math.random() * sequence.length) + 1;
			
			FlxG.play(SndFight);
			
			activeSequence = true;
		}
		
		private function checkMovement():void
		{
			if(currentArrow == 1)
			{
				if(FlxG.keys.justPressed("UP"))
				{
					enemy.damage();
					activeSequence = false;
				}
				else if(FlxG.keys.justPressed("LEFT") || FlxG.keys.justPressed("DOWN") || FlxG.keys.justPressed("RIGHT"))
				{
					enemy.win();
				}
			}
			if(currentArrow == 2)
			{
				if(FlxG.keys.justPressed("DOWN"))
				{
					enemy.damage();
					activeSequence = false;
				}
				else if(FlxG.keys.justPressed("UP") || FlxG.keys.justPressed("LEFT") || FlxG.keys.justPressed("RIGHT"))
				{
					enemy.win();
				}
				
			}
			if(currentArrow == 3)
			{
				if(FlxG.keys.justPressed("LEFT"))
				{
					enemy.damage();
					activeSequence = false;
				}
				else if(FlxG.keys.justPressed("UP") || FlxG.keys.justPressed("DOWN") || FlxG.keys.justPressed("RIGHT"))
				{
					enemy.win();
				}

			}
			if(currentArrow == 4)
			{
				if(FlxG.keys.justPressed("RIGHT"))
				{
					enemy.damage();
					activeSequence = false;
				}
				else if(FlxG.keys.justPressed("UP") || FlxG.keys.justPressed("DOWN") || FlxG.keys.justPressed("LEFT"))
				{
					enemy.win();
				}

			}


		}
		
		public function pushMe():void
		{
			this.flicker(0.5);
			//isFighting = false;
			isPushed = true;
			if(Math.round(Math.random() * 2) == 0)
			{
				velocity.x = -(6 * drag.x);	
			}
			else
			{
				velocity.x = +(6 * drag.x);
			}
			isFighting = false;
			enemy = null;
			FlxG.play(SndLose);
		}
		
		override public function update():void
		{
			isChanging = false;
			visible = true;
			if (isPushed)
			{
				this.pushTimer--;
				isFighting = false;
				enemy = null;
				
				if(pushTimer <= 0)
				{
					pushTimer = pushTimerMax;
					isPushed = false;
				}
			}
			//MOVEMENT
			acceleration.x = 0;
			
			if(isFighting)
			{
				timer--;
				
				if(timer <= 0)
				{
					enemy.win();
					timer = maxTimer;
				}
				
				visible = false;
				createSequence();
				
				checkMovement();
				
				play("idle");
				
				super.update();
				return;
			}
			
			angle = 0;
			
			if(FlxG.keys.LEFT)
			{
				facing = LEFT;
				acceleration.x -= drag.x;
			}
			else if(FlxG.keys.RIGHT)
			{
				facing = RIGHT;
				acceleration.x += drag.x;
			}
			if(FlxG.keys.justPressed("UP") && this.isTouching(FlxObject.DOWN))
			{
				velocity.y = -_jumpPower;
				FlxG.play(SndJump);
			}
			
			if (velocity.x && !velocity.y)
			{
				if(this.hasPaper)
					play("walkPaper");
				else
					play("walk");
			}
			else if (velocity.y)
			{
				if(this.hasPaper)
					play("jumpPaper");
				else
					play("jump");
			}
			else
			{
				if(hasPaper)
					play("idlePaper");
				else
					play("idle");
			}
			
			if(isFighting)
			{
				play("idle");
			}
			
			if(FlxG.keys.justPressed("SPACE"))
			{
				this.isActivating = true;
			}
			else
				isActivating = false;
			
			if(x <= 20)
			{
				x = 20;
			}
			
			if(x >= 800)
			{
				x = 800;
			}
			
			super.update();

		}
	}
}