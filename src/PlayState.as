package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.FlxButtonPlus;
	import org.flixel.plugin.photonstorm.FlxSpecialFX;
	import com.adobe.tako.*;

	
	public class PlayState extends FlxState
	{
		public var helloText:FlxText;
		//public var ground:FlxSprite;
		public var box:FlxSprite;
		private var player:Player;
		private var cameraFocusObject:FlxObject;
		private var HUD:Hud;
		private var goal:Goal;
		private var floorsGroup:FlxGroup;
		
		private var ground:FlxTilemap;
		
		private var backgroundsGroup:FlxGroup;
		private var enemiesGroup:FlxGroup;
		private var roofsGroup:FlxGroup;
		private var doorsGroup:FlxGroup;
		
		[Embed(source="ground.png")] protected var groundClass:Class;
		[Embed(source="box.png")] protected var imgBox:Class;
		[Embed(source="level1.png")] protected var ImgMap:Class;
		[Embed(source="level1Entities.png")] protected var ImgEntities:Class;
		[Embed(source="restartButton.png")] protected var ImgRestartButton:Class;
		
		[Embed(source="HUD.png")] protected var ImgHUDBG:Class;

		[Embed(source="tiles.png")] protected var ImgTiles:Class;
		[Embed(source="tech_tiles.png")] protected var ImgTiles2:Class;
		[Embed(source="worldTiles.png")] protected var ImgTiles3:Class;		
		[Embed(source="auto_tiles.png")] protected var ImgTiles4:Class;		
		[Embed(source="newTiles.png")] protected var ImgTiles5:Class;
		[Embed(source="gameover.png")] protected var ImgGOTiles5:Class;

		[Embed(source="gameover.png")] protected var ImgMenu:Class;
		[Embed(source="redo.png")] protected var ImgRedo:Class;
		[Embed(source="menu.png")] protected var ImgToMenu:Class;
		
		[Embed(source="background.jpg")] protected var ImgBG:Class;
		[Embed(source="arrows.png")] protected var ImgArrows:Class;
		
		[Embed(source="sideWalk.png")] protected var ImgSideWalk:Class;
		[Embed(source="door1.png")] protected var ImgDoor1:Class;
		
		[Embed(source="fightCloud.png")] protected var ImgFightCloud:Class;

		[Embed(source="pixelArrow.png")] protected var ImgPixelArrow:Class;
		
		private var winNumber:Number = 5;
		
		public var levelTimer:FlxTimer;
		
		public var fightCloud:FlxSprite;
		
		public var arrows:FlxSprite;
		
		public var checkText:FlxText;
		
		private var platformsGroup:FlxGroup;
		
		[Embed(source = 'default_auto.txt', mimeType = 'application/octet-stream')]private static var default_auto:Class;
		
		[Embed(source="andlso.ttf",fontFamily="arabicF",embedAsCFF="false")] protected var arabicFont:String;
		
		private var isGameOver:Boolean = false;
		
		private var timerText:FlxText;
		
		private var pixelArrow:FlxSprite;
		
		private function timerCallBack(TIMER:FlxTimer):void
		{
			FlxG.flash();
			//var goScreen:GameOverScreen = new GameOverScreen();
			//add(goScreen);
			add(new FlxSprite(200, player.y - 200, ImgGOTiles5));
			

			/*
			var restartButton:FlxButton = new FlxButton(150 + 20, player.y - 200, "", restartGame);
			restartButton.loadGraphic(ImgRedo);
			var menuButton:FlxButton = new FlxButton(150 + 200, player.y - 200, "", gotoMenu);
			menuButton.loadGraphic(ImgToMenu);
			//var menuButton:FlxButtonPlus = new FlxButtonPlus(200, ground.height - 100, gotoMenu);
			//menuButton.loadGraphic(new FlxSprite(0, 0, ImgFightCloud), new FlxSprite(0, 0, ImgFightCloud));
			//FlxButton.
			
			add(restartButton);
			add(menuButton);

			gotoMenu()
			
			isGameOver = true;
			*/
			restartGame();
		}

		public function restartGame():void
		{
			FlxG.resetState();
		}
		
		public function gotoMenu():void
		{
			FlxG.switchState(new MenuState());	
		}

		
		override public function create():void
		{
			this.winNumber = 4;
			Globals.winNumber = winNumber;
			
			isGameOver = false;
			
			doorsGroup = new FlxGroup();

			pixelArrow = new FlxSprite(389, 5);
			pixelArrow.loadGraphic(ImgPixelArrow, true, false, 23, 32);
			pixelArrow.addAnimation("loop", [0, 1, 2, 3, 2, 1], 12, true);
			pixelArrow.play("loop");
			
			levelTimer = new FlxTimer();
			levelTimer.start(100, 1, timerCallBack);
			timerText = new FlxText(580, 13, 200, "");
			timerText.alignment = "right";
			timerText.size = 16;
			timerText.scrollFactor = new FlxPoint();
			
			checkText = new FlxText(20, 20, 200, "NOTHING");
			checkText.size = 20;
			checkText.scrollFactor = new FlxPoint();
			
			FlxG.framerate = 60;
			FlxG.flashFramerate = 60;
			
			arrows = new FlxSprite(0, 0);
			arrows.loadGraphic(ImgArrows, true);
			
			floorsGroup = new FlxGroup();
			
			enemiesGroup = new FlxGroup();
			
			backgroundsGroup = new FlxGroup();
			platformsGroup = new FlxGroup();
			
			fightCloud = new FlxSprite(0, 0);
			fightCloud.loadGraphic(ImgFightCloud, true, false, 71, 60);
			fightCloud.addAnimation("loop", [0, 1, 2, 3, 2, 1], 20, true);
			fightCloud.play("loop");
			fightCloud.visible = false;
			
			Globals.resetLevel(5);
			
			roofsGroup = new FlxGroup();
			
			var levelBG:FlxSprite = new FlxSprite(0, 0, ImgBG);
			levelBG.scrollFactor = new FlxPoint();
			add(levelBG);
			
			add(backgroundsGroup);
			add(doorsGroup);
			add(floorsGroup);
			add(roofsGroup);
			add(platformsGroup);
			
			// Create the ground, based on an image:
			readGroundMap(ImgMap, ImgTiles5, 16, 16);
			readEntities(ImgEntities, 16, 16);
			
			add(enemiesGroup);
			
			var sideWalk:FlxSprite = new FlxSprite(16, ground.height - 16, ImgSideWalk);
			add(sideWalk);
			
			
			FlxG.mouse.show();
															
			add(ground);
			
			add(Globals.cratesGroup);
			add(Globals.spikesGroup);
			add(Globals.springsGroup);
			HUD = new Hud();
			//add(HUD);
				
			var HUDBG:FlxSprite = new FlxSprite(0, 0, ImgHUDBG);
			HUDBG.scrollFactor = new FlxPoint();
			add(HUDBG);
			
			pixelArrow.scrollFactor = new FlxPoint();
			add(pixelArrow);
			
			FlxG.camera.flash(0xffffff, 1);
			
			cameraFocusObject = new FlxObject();
			cameraFocusObject.x = player.x;
			cameraFocusObject.y = player.y - 70;
			add(cameraFocusObject);
						
			FlxG.camera.follow(cameraFocusObject, FlxCamera.STYLE_PLATFORMER);
			FlxG.camera.setBounds(16,0,800,ground.height); //the hard way
			FlxG.worldBounds = new FlxRect(0, 0, 832, ground.height);
			
			FlxG.camera.bgColor = 0xFF8888FF;
			
			add(arrows);
			
			//add(checkText);

			var paper;
			
			for(var i:Number = 0; i < 5; i++)
			{
				var rand:int = Math.random() * 3;
				
				switch(rand)
				{
					case(0):
						paper = floorsGroup.getRandom();
					break;
					case(1):
						paper = doorsGroup.getRandom();
					break;
					case(2):
						paper = roofsGroup..getRandom();
					break;
					default:
						paper = floorsGroup.getRandom();
				}

				rand = Math.random() * 3;
				switch(rand)
				{
					case(0):
						paper.setCompany(floorsGroup.getRandom());
						break;
					case(1):
						paper.setCompany(doorsGroup.getRandom());
						break;
					case(2):
						paper.setCompany(roofsGroup.getRandom());
						break;
					default:
						paper.setCompany(floorsGroup.getRandom());
				}
				
				Globals.papersArray.push(paper);
			}
			
			Globals.papersArray[0].makePaper();
			
			
			add(fightCloud);
			
			//add(checkText);
			add(timerText);
			ground.visible = false;
			
			//add(new FlxButton(500, ground.height - 200, "HIIIII", FlxG.resetState));
			
						
		}
		
		private function readGroundMap(MAP:Class, TILES:Class, WIDTH:int = 8, HEIGHT:int = 8):void
		{
			ground = new FlxTilemap();
			ground.loadMap(FlxTilemap.imageToCSV(MAP, false, 1), TILES, WIDTH, HEIGHT, FlxTilemap.AUTO);
			Globals.ground = ground;
		}
		
		private function readEntities(PNGFile:Class, WIDTH:int = 16, HEIGHT:int = 16, Invert:Boolean=false,Scale:uint=1):void
		{
			//Import and scale image if necessary
			var layout:Bitmap;
			if(Scale <= 1)
				layout = new PNGFile;
			else
			{
				var tmp:Bitmap = new PNGFile;
				layout = new Bitmap(new BitmapData(tmp.width*Scale,tmp.height*Scale));
				var mtx:Matrix = new Matrix();
				mtx.scale(Scale,Scale);
				layout.bitmapData.draw(tmp,mtx);
			}
			var bd:BitmapData = layout.bitmapData;
			
			//Walk image and export pixel values
			var r:uint;
			var c:uint;
			var p:uint;
			var csv:String;
			var w:uint = layout.width;
			var h:uint = layout.height;
			for(r = 0; r < h; r++)
			{
				for(c = 0; c < w; c++)
				{
					//Decide if this pixel/tile is solid (1) or not (0)
					p = bd.getPixel(c,r);
					//Write the result to the string
					
					if(p == 0x00ff00)
					{
						player = new Player(c * WIDTH, r * HEIGHT);
						Globals.player = player
						add(player);
					}
					if(p == 0x8f0000) // || p == 0x226197 || p == 0x595959)
					{
						//goal = new Goal(c * WIDTH, r * HEIGHT, Level2);
						doorsGroup.add(new Door(c * WIDTH, r * HEIGHT, 1));
					}
					if(p == 0x226197) // || p == 0x226197 || p == 0x595959)
					{
						//goal = new Goal(c * WIDTH, r * HEIGHT, Level2);
						doorsGroup.add(new Door(c * WIDTH, r * HEIGHT, 2));
					}
					if(p == 0x595959) // || p == 0x226197 || p == 0x595959)
					{
						//goal = new Goal(c * WIDTH, r * HEIGHT, Level2);
						doorsGroup.add(new Door(c * WIDTH, r * HEIGHT, 3));
					}

					if(p == 0xc11717) // || p == 0x207ecd || p == 0x989999)
					{
						floorsGroup.add(new Floor(c * WIDTH, r * HEIGHT, 1));
					}	
					
					if(p == 0x207ecd) // || p == 0x207ecd || p == 0x989999)
					{
						floorsGroup.add(new Floor(c * WIDTH, r * HEIGHT, 2));
					}					
					if(p == 0x989999) // || p == 0x207ecd || p == 0x989999)
					{
						floorsGroup.add(new Floor(c * WIDTH, r * HEIGHT, 3));
					}					

					
					if(p == 0x6b0000) // || p == 0x182b3b || p == 0x292929)
					{
						roofsGroup.add(new Roof(c * WIDTH, r * HEIGHT, 1));
					}
					if(p == 0x182b3b) // || p == 0x182b3b || p == 0x292929)
					{
						roofsGroup.add(new Roof(c * WIDTH, r * HEIGHT, 2));
					}
				
					if(p == 0x292929) // || p == 0x182b3b || p == 0x292929)
					{
						roofsGroup.add(new Roof(c * WIDTH, r * HEIGHT, 3));
					}
					
					if(p == 0xffa3a3) // || p == 0x98bfe1 || p == 0xb3b3b3)
					{
						platformsGroup.add(new Platform(c * WIDTH, r * HEIGHT + 10, 1));
					}
					if(p == 0x98bfe1) // || p == 0x98bfe1 || p == 0xb3b3b3)
					{
						platformsGroup.add(new Platform(c * WIDTH, r * HEIGHT + 10, 2));
					}
					if(p == 0xb3b3b3) // || p == 0x98bfe1 || p == 0xb3b3b3)
					{
						platformsGroup.add(new Platform(c * WIDTH, r * HEIGHT + 10, 3));
					}
					
					if(p == 0x48df4f) // || p == 0x98bfe1 || p == )
					{
						enemiesGroup.add(new Enemy(c * WIDTH, r * HEIGHT - 32));
					}
				}
			}
		}		
				
		private function win():void
		{
			FlxG.switchState(new Level2);
		}
		
		override public function update():void
		{
			if(isGameOver)
			{
				//super.update();
				return;
			}
			
			pixelArrow.visible = false;
			
			if(!Globals.goal.onScreen()) 
			{
				pixelArrow.visible = true;
				if(Globals.goal.y > player.y)
				{
					pixelArrow.angle = 0;
				}
				else
					pixelArrow.angle = 180;
			}
				
			if(Globals.winNumber <= 0)
			{
				win();
			}
			
			timerText.text = String(FlxU.formatTime(levelTimer.timeLeft));
			
			arrows.x = player.x + 10;
			arrows.y = player.y - 40;
			
			arrows.visible = false;

			checkText.text = String(player.isPushed);
			
			fightCloud.x = player.x - 10;
			fightCloud.y = player.y;
			
			fightCloud.visible = false;
			
			if(player.isFighting)
			{

				fightCloud.visible = true;
				arrows.frame = player.currentArrow - 1;
				arrows.visible = true;
				if(player.isChanging)
				{
					arrows.flicker(0.1);
				}
			}

			cameraFocusObject.x = player.x;
			cameraFocusObject.y = player.y;

			FlxG.collide(ground, player);
			FlxG.collide(player, platformsGroup);
			FlxG.collide(player, roofsGroup);
			FlxG.collide(ground, enemiesGroup);
			FlxG.collide(platformsGroup, enemiesGroup);
			FlxG.collide(enemiesGroup, roofsGroup);
			
			HUD.updateMe();
			
			super.update();
			
			if(Globals.isGameOver)
			{
				FlxG.resetState();
			}
			
		}
	}
}