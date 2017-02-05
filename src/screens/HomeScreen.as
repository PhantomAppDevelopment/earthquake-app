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
			this.layout = new VerticalLayout(); //We are going to use a layout where items will be stacked vertically

			/*
			 We create 4 identical buttons using a helper function that will return us a new Button with predefined properties.
			 By using the helper function we save several lines of code and we only need to set individual EventListeners.

			 Scroll to the bottom to see how the helper function uses the parameters and creates our new buttons.

			 When the button gets TRIGGERED (clicked/pressed/tapped) we are going to call a custom function named goNextScreen().
			 This function takes 2 parameters. A String containing the title and a String containing an URL.
			 */
			var button1:Button = generateMenuButton("Past Hour", "assets/icons/hour.png");
			button1.addEventListener(Event.TRIGGERED, function ():void
			{
				goNextScreen("Past Hour", "http://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_hour.geojson");
			})
			this.addChild(button1);

			/*
			 Button 2 block
			 */
			var button2:Button = generateMenuButton("Past Day", "assets/icons/day.png")
			button2.addEventListener(Event.TRIGGERED, function ():void
			{
				goNextScreen("Past Day", "http://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_day.geojson");
			})
			this.addChild(button2);

			/*
			 Button 3 block
			 */
			var button3:Button = generateMenuButton("Past Week", "assets/icons/week.png")
			button3.addEventListener(Event.TRIGGERED, function ():void
			{
				goNextScreen("Past Week", "http://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_week.geojson");
			})
			this.addChild(button3);

			/*
			 Button 4 block
			 */
			var button4:Button = generateMenuButton("Past Month", "assets/icons/month.png");
			button4.addEventListener(Event.TRIGGERED, function ():void
			{
				goNextScreen("Past Month", "http://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_month.geojson");
			})
			this.addChild(button4);

			System.gc(); //This function will call the garbage collector everytime we come back to the main menu
		}

		/*
		 This helper function will create and return a Button and an ImageLoader as its default icon.
		 This function requires 2 parameters, a desired label text for the button and a file path for its default icon.
		 This kind of function is useful for avoiding the repetition of identical code.

		 The layoutData value means that we want it to fit 100% horizontally and 25% vertically in the screen.
		 */
		private function generateMenuButton(buttonLabel:String, iconPath:String):Button
		{
			var tempIcon:ImageLoader = new ImageLoader();
			tempIcon.source = iconPath;
			tempIcon.width = tempIcon.height = 40;

			var tempButton:Button = new Button();
			tempButton.label = buttonLabel;
			tempButton.defaultIcon = tempIcon;
			tempButton.styleNameList.add("horizontal-button");
			tempButton.layoutData = new VerticalLayoutData(100, 25);
			return tempButton;
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