package
{
	import feathers.controls.StackScreenNavigator;
	import feathers.controls.StackScreenNavigatorItem;
	import feathers.motion.Slide;

	import screens.HomeScreen;
	import screens.ListDetails;
	import screens.QuakeDetails;

	import starling.display.Sprite;
	import starling.events.Event;

	public class Main extends Sprite
	{
		/*
		 We declare the IDs of the screens our app is going to use.
		 */
		private static const HOME_SCREEN:String = "homeScreen";
		private static const LIST_DETAILS_SCREEN:String = "listDetailsScreen";
		private static const QUAKE_DETAILS_SCREEN:String = "quakeDetailsScreen";

		private var NAVIGATOR_DATA:NavigatorData; //This is a dynamic class which will hold our app's data

		public function Main()
		{
			this.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}

		protected function addedToStageHandler(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);

			this.NAVIGATOR_DATA = new NavigatorData(); //We instantiate our NAVIGATOR_DATA once so it is ready to be used by any screen.

			/*
			 We initialize our theme and the Feathers framework will automatically skin the UI controls once they are added to the stage.
			 */
			new CustomTheme();

			/*
			 We are going to wire up the app with a StackScreenNavigator and add all the screens.
			 The NAVIGATOR_DATA is shared between all the screens.

			 We are going to use the same push and pop transition for all the screens.
			 */
			var myNavigator:StackScreenNavigator = new StackScreenNavigator();
			myNavigator.pushTransition = Slide.createSlideLeftTransition();
			myNavigator.popTransition = Slide.createSlideRightTransition();
			this.addChild(myNavigator);

			/*
			 The GO_LIST_DETAILS constant is located inside the HomeScreen class.
			 When the navigator receives an event with that name it will push the LIST_DETAILS_SCREEN into the stack.
			 When it receives an starling.events.Event.COMPLETE it will pop the current screen from the stack.
			 */
			var homeScreenItem:StackScreenNavigatorItem = new StackScreenNavigatorItem(HomeScreen);
			homeScreenItem.properties.data = NAVIGATOR_DATA;
			homeScreenItem.setScreenIDForPushEvent(HomeScreen.GO_LIST_DETAILS, LIST_DETAILS_SCREEN);
			myNavigator.addScreen(HOME_SCREEN, homeScreenItem);

			var listDetailsScreenItem:StackScreenNavigatorItem = new StackScreenNavigatorItem(ListDetails);
			listDetailsScreenItem.properties.data = NAVIGATOR_DATA;
			listDetailsScreenItem.addPopEvent(Event.COMPLETE);
			listDetailsScreenItem.setScreenIDForPushEvent(ListDetails.GO_QUAKE_DETAILS, QUAKE_DETAILS_SCREEN);
			myNavigator.addScreen(LIST_DETAILS_SCREEN, listDetailsScreenItem);

			var quakeDetailsScreenItem:StackScreenNavigatorItem = new StackScreenNavigatorItem(QuakeDetails);
			quakeDetailsScreenItem.properties.data = NAVIGATOR_DATA;
			quakeDetailsScreenItem.addPopEvent(Event.COMPLETE);
			myNavigator.addScreen(QUAKE_DETAILS_SCREEN, quakeDetailsScreenItem);

			myNavigator.rootScreenID = HOME_SCREEN; //We set the root screen (the one will be shown first).
		}

	}
}