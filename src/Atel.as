package
{
	import org.flixel.*; //Allows you to refer to flixel objects in your code
//	import com.adobe.tako;
	
	[SWF(width="800", height="600", backgroundColor="#000000")] //Set the size and color of the Flash file
	[Frame(factoryClass="Preloader")] //Tells Flixel to use the default preloader
	
	
	
	
	public class HelloWorld extends FlxGame
	{
		public function HelloWorld()
		{
			super(800,600,MenuState,1); //Create a new FlxGame object at 320x240 with 2x pixels, then load PlayState
		}
	}
}