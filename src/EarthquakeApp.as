package
{
	import feathers.utils.ScreenDensityScaleFactorManager;

	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.display3D.Context3DRenderMode;
	import flash.events.Event;

	import starling.core.Starling;

	[SWF(width="320", height="480", frameRate="60", backgroundColor="#455A64")]
	public class EarthquakeApp extends Sprite
	{
		private var myStarling:Starling;
		private var myScaler:ScreenDensityScaleFactorManager;

		/*
		 All of this file is the required code to set up a Starling application that uses the Feathers ScreenDensityScaleFactorManager.
		 */
		public function EarthquakeApp()
		{
			if (this.stage) {
				this.stage.scaleMode = StageScaleMode.NO_SCALE;
				this.stage.align = StageAlign.TOP_LEFT;
			}
			this.mouseEnabled = this.mouseChildren = false;
			this.loaderInfo.addEventListener(Event.COMPLETE, loaderInfo_completeHandler);
		}

		private function loaderInfo_completeHandler(event:Event):void
		{
			Starling.multitouchEnabled = true;

			this.myStarling = new Starling(Main, this.stage, null, null, Context3DRenderMode.AUTO, "auto"); //Main is the Main.as file which extends Starling Sprite.
			this.myScaler = new ScreenDensityScaleFactorManager(this.myStarling);
			this.myStarling.enableErrorChecking = false;
			this.myStarling.skipUnchangedFrames = true; //Improves performance by only rendering when objects actually moving.
			this.myStarling.showStats = true; //Shows a stats box where you can see how many resources the app is using.
			this.myStarling.start();

			this.stage.addEventListener(Event.DEACTIVATE, stage_deactivateHandler, false, 0, true);
		}

		/*
		 If the app goes to the background we stop rendering to save energy.
		 */
		private function stage_deactivateHandler(event:Event):void
		{
			this.myStarling.stop();
			this.stage.addEventListener(Event.ACTIVATE, stage_activateHandler, false, 0, true);
		}

		/*
		 When the app comes back from the background we start rendering again.
		 */
		private function stage_activateHandler(event:Event):void
		{
			this.stage.removeEventListener(Event.ACTIVATE, stage_activateHandler);
			this.myStarling.start();
		}

	}
}