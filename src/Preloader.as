package
{
	import org.flixel.system.FlxPreloader;
	import com.adobe.tako.*;

		
		public class Preloader extends FlxPreloader
		{
			
			public function Preloader():void
			{
				className = "HelloWorld";
				//this.myURL = "gametako.com"
				super();
			}
		}
}