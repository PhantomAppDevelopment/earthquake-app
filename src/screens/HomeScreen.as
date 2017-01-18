package screens
{
	import feathers.controls.Button;
	import feathers.controls.ImageLoader;
	import feathers.controls.PanelScreen;
	import feathers.layout.VerticalLayout;
	import feathers.layout.VerticalLayoutData;

	import flash.system.System;

	import starling.events.Event;

	public class HomeScreen extends PanelScreen
	{
		public static const GO_LIST_DETAILS:String = "goListDetails";

		/*
		 This variable and the next 2 functions are boilerplate code that will create a getter and setter for the 'data' property.
		 The other screens contain the same code since they will also require this property to correctly function.
		 */
		protected var _data:NavigatorData;

		public function get data():NavigatorData
		{
			return this._data;
		}

		public function set data(value:NavigatorData):void
		{
			this._data = value;
		}

		/*
		 This is our HomeScreen that will serve as a Main menu. To add UI elements we override the initialize method.
		 A PanelScreen consists of 3 elements, a header, a footer and a ScrollContainer.

		 In this app we only make use of the Header and  the ScrollContainer.
		 The Header can contain any UI control, most commonly are Labels, Buttons and ImageLoaders.
		 The ScrollContainer can also include any UI control, in this case it will contain 4 buttons.
		 */
		override protected function initialize():void
		{
			super.initialize();

			this.title = "Earthquakes"; //The title that will appear in the header
			this.layout = new VerticalLayout(); //We are going to use a layout where items will be stacked verticallly

			/*
			 We create a button and customize its look by setting its icon from a helper function that returns
			 a new ImageLoader. The helper function requires one String parameter which is the file path of the icon.

			 We also set its label and assigned an specific style from the theme.

			 The layoutData value means that we want it to fit 100% horizontally and 25% vertically in the screen.
			 When the button gets TRIGGERED (clicked/pressed/tapped) we are going to call a custom function named goNextScreen().
			 This function takes 2 parameters. A String containing the title and a String containing an URL.
			 */
			var button1:Button = new Button();
			button1.addEventListener(Event.TRIGGERED, function ():void
			{
				goNextScreen("Past Hour", "http://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_hour.geojson");
			})
			button1.label = "Past Hour";
			button1.defaultIcon = generateIcon("assets/icons/hour.png");
			button1.styleNameList.add("horizontal-button");
			button1.layoutData = new VerticalLayoutData(100, 25);
			this.addChild(button1);

			/*
			 Button 2 block
			 */
			var button2:Button = new Button();
			button2.addEventListener(Event.TRIGGERED, function ():void
			{
				goNextScreen("Past Day", "http://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_day.geojson");
			})
			button2.label = "Past Day";
			button2.defaultIcon = generateIcon("assets/icons/day.png");
			button2.styleNameList.add("horizontal-button");
			button2.layoutData = new VerticalLayoutData(100, 25);
			this.addChild(button2);

			/*
			 Button 3 block
			 */
			var button3:Button = new Button();
			button3.addEventListener(Event.TRIGGERED, function ():void
			{
				goNextScreen("Past Week", "http://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_week.geojson");
			})
			button3.label = "Past Week";
			button3.styleNameList.add("horizontal-button");
			button3.defaultIcon = generateIcon("assets/icons/week.png");
			button3.layoutData = new VerticalLayoutData(100, 25);
			this.addChild(button3);

			/*
			 Button 4 block
			 */
			var button4:Button = new Button();
			button4.addEventListener(Event.TRIGGERED, function ():void
			{
				goNextScreen("Past Month", "http://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_month.geojson");
			})
			button4.label = "Past Month";
			button4.defaultIcon = generateIcon("assets/icons/month.png");
			button4.styleNameList.add("horizontal-button");
			button4.layoutData = new VerticalLayoutData(100, 25);
			this.addChild(button4);

			System.gc(); //This function will call the garbage collector everytime we come back to the main menu
		}

		/*
		This helper function will create and return an ImageLoader containing the icon specified in the path parameter.
		This is useful for avoiding the repetition of identical code.
		 */
		private function generateIcon(path:String):ImageLoader
		{
			var tempIcon:ImageLoader = new ImageLoader();
			tempIcon.source = path;
			tempIcon.width = tempIcon.height = 40;
			return tempIcon;
		}

		/*
		 This function is called when one of the buttons gets TRIGGERED (clicked,pressed/tapped).
		 This function saves the parameters into the NAVIGATOR_DATA Object.
		 It finally dispatches the GO_LIST_DETAILS event which the StackScreenNavigator is listening to.
		 */
		private function goNextScreen(label:String, url:String):void
		{
			_data.selectedLabel = label;
			_data.selectedURL = url;
			this.dispatchEventWith(GO_LIST_DETAILS);
		}
	}
}