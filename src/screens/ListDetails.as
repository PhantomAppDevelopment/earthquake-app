package screens
{
	import feathers.controls.Button;
	import feathers.controls.List;
	import feathers.controls.PanelScreen;
	import feathers.data.ListCollection;
	import feathers.events.FeathersEventType;
	import feathers.layout.VerticalLayout;
	import feathers.layout.VerticalLayoutData;

	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	import starling.display.DisplayObject;
	import starling.events.Event;

	public class ListDetails extends PanelScreen
	{
		public static const GO_QUAKE_DETAILS:String = "goQuakeDetails";

		private var quakesList:List;

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
		 This screen will connect to the web API and show a list of recent earthquakes.
		 It reads the values that we passed from the previous screen in the goNextScreen function.
		 It also remembers which earthquake was selected and automatically scrolls to it.
		 */
		override protected function initialize():void
		{
			super.initialize();

			/*
			 The header title for this screen is dynamic, it is composed by 2 Strings:
			 "Earthquakes, " and the title that was passed in the function showNextScreen()
			 */
			this.title = "All Earthquakes, " + _data.selectedLabel;
			this.layout = new VerticalLayout();
			this.backButtonHandler = goBack; //The goBack function will be called when the Back button is pressed on an Android device.

			/*
			 We create a button that will serve as a back button as seen in most apps.
			 When this button is TRIGGERED it will call the goBack function.
			 We pass a style from the theme that will automatically add a back arrow and a semi transparent background when it is being pressed.
			 Instead of using the addChild() method, we add it directly to the leftItems container as a Vector of Starling DisplayObject.
			 */
			var backButton:Button = new Button();
			backButton.styleNameList.add("back-button");
			backButton.addEventListener(starling.events.Event.TRIGGERED, goBack);
			this.headerProperties.leftItems = new <DisplayObject>[backButton];

			quakesList = new List();
			quakesList.layoutData = new VerticalLayoutData(100, 100); //Our list will fit the horizontal and vertical space by 100%
			quakesList.itemRendererType = QuakeRenderer; //We are going to use our own ItemRenderer, the class name is QuakeRenderer
			this.addChild(quakesList);

			/*
			 We are going to wait until the screen transition has completely finished to start loading our data from the API.
			 This way we avoid stuttering caused by doing several actions at the same time.
			 */
			this.addEventListener(FeathersEventType.TRANSITION_IN_COMPLETE, transitionComplete);
		}

		private function transitionComplete(event:starling.events.Event):void
		{
			this.removeEventListener(FeathersEventType.TRANSITION_IN_COMPLETE, transitionComplete);

			/*
			 We check if there's saved data, if not we request fresh one
			 In case there's existing data we will scroll to the previously selected earthquake.
			 */
			if (_data.dataProvider) {
				quakesList.dataProvider = _data.dataProvider;
				quakesList.scrollToDisplayIndex(_data.selectedIndex);
				quakesList.selectedIndex = _data.selectedIndex;
				quakesList.addEventListener(starling.events.Event.CHANGE, changeHandler);
			} else {

				/*
				 This is the most basic way to connect to a web API. We create an URLRequest
				 with the URL passed from the goNextScreen function.

				 Then we create an URLLoader and pass the URLRequest as its parameter.

				 Notice that the URLLoader listens to a flash.events.Event.COMPLETE event
				 be careful to not use a starling.events.Event.COMPLETE event.
				 */
				var request:URLRequest = new URLRequest(_data.selectedURL);
				var loader:URLLoader = new URLLoader();
				loader.addEventListener(flash.events.Event.COMPLETE, quakesLoaded);
				loader.load(request);
			}
		}

		/*
		 Once we receive the response from the web API we convert it to an AS3 Object using the JSON class.
		 Then we create the DataProvider for the List by casting the AS3 Object as an Array.

		 We finally dispose of the JSON object since it is not needed anymore and we add an event listener to the list
		 so it can know when an item has been selected.
		 */
		private function quakesLoaded(event:flash.events.Event):void
		{
			event.currentTarget.removeEventListener(flash.events.Event.COMPLETE, quakesLoaded);

			var rawData:Object = JSON.parse(event.currentTarget.data);
			quakesList.dataProvider = new ListCollection(rawData.features as Array);
			rawData = null;

			quakesList.addEventListener(starling.events.Event.CHANGE, changeHandler);
		}

		/*
		 When an item from the list gets selected we want to save which one was pressed and what was its index.
		 We also store a copy of the data provider so we can restore it faster and avoid calling the API again.
		 */
		private function changeHandler(event:starling.events.Event):void
		{
			quakesList.removeEventListener(starling.events.Event.CHANGE, changeHandler);
			_data.selectedQuake = quakesList.selectedItem;
			_data.selectedIndex = quakesList.selectedIndex;
			_data.dataProvider = quakesList.dataProvider;
			this.dispatchEventWith(GO_QUAKE_DETAILS);
		}

		/*
		 The goBack function is rather simple. It cleans out variables and properties that are not going to be used anymore.
		 */
		private function goBack():void
		{
			_data.dataProvider = null;
			_data.selectedIndex = null;

			this.dispatchEventWith(starling.events.Event.COMPLETE);
		}

	}
}