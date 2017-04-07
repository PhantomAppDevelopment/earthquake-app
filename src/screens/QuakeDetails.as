package screens
{
	import feathers.controls.Button;
	import feathers.controls.ImageLoader;
	import feathers.controls.Label;
	import feathers.controls.LayoutGroup;
	import feathers.controls.PanelScreen;
	import feathers.events.FeathersEventType;
	import feathers.layout.HorizontalAlign;
	import feathers.layout.TiledRowsLayout;
	import feathers.layout.VerticalLayout;
	import feathers.layout.VerticalLayoutData;

	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	import starling.display.DisplayObject;
	import starling.events.Event;
	import starling.text.TextFormat;

	public class QuakeDetails extends PanelScreen
	{

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
		 This screen will show the most important information about the selected earthquake, including a tile map from OSM.
		 */
		override protected function initialize():void
		{
			super.initialize();

			this.title = "Quake Details";
			this.backButtonHandler = goBack;

			var myLayout:VerticalLayout = new VerticalLayout();
			myLayout.horizontalAlign = HorizontalAlign.CENTER;
			myLayout.gap = 5;
			this.layout = myLayout;

			var backButton:Button = new Button();
			backButton.styleNameList.add("back-button");
			backButton.addEventListener(starling.events.Event.TRIGGERED, goBack);
			this.headerProperties.leftItems = new <DisplayObject>[backButton];

			this.addEventListener(FeathersEventType.TRANSITION_IN_COMPLETE, transitionComplete);
		}

		/*
		 Once our screen transition has finished we are goign to connect to the web API once more
		 ann request detailed information about the quake.

		 THe URL provided for the URLRequest is taken directly from the previous API call and its
		 stored in the selectedQuake.properties.detail property.
		 */
		private function transitionComplete(event:starling.events.Event):void
		{
			this.removeEventListener(FeathersEventType.TRANSITION_IN_COMPLETE, transitionComplete);

			var request:URLRequest = new URLRequest(_data.selectedQuake.properties.detail);

			var loader:URLLoader = new URLLoader();
			loader.addEventListener(flash.events.Event.COMPLETE, quakeDetailsLoaded);
			loader.load(request);
		}

		/*
		 Once our detailed data has been loaded we start to present it in a table.

		 This table is a LayoutGroup with a TiledLayout with a maximum of 2 columns.
		 Since we are adding labels in pairs we are guaranteed that our table structure is correct.

		 Notice that we also add the UI elements from top to bottom, starting with the title and image
		 and finishing with all the quake details in pairs.
		 */
		private function quakeDetailsLoaded(event:flash.events.Event):void
		{
			event.currentTarget.removeEventListener(flash.events.Event.COMPLETE, quakeDetailsLoaded);

			var rawData:Object = JSON.parse(event.currentTarget.data);

			var placeLabel:Label = new Label();
			placeLabel.layoutData = new VerticalLayoutData(100, NaN);
			placeLabel.wordWrap = true;
			placeLabel.padding = 10;
			placeLabel.fontStyles = new TextFormat("MyFont", 24, 0xFFFFFF);
			placeLabel.text = rawData.properties.place;
			this.addChild(placeLabel);

			/*
			 To add a tile map we have to prepare 3 variables, latitude, longitude and the zoom level.
			 We take the 2 first from the API response and we manually set the zoom level at our liking.

			 The long2tile and lat2tile functions take the coordinates and zoom level as parameters and
			 they return the tile address from the OSM server.

			 We finally tell the ImageLoader to load the tile from the OSM server.
			 */
			var zoom:Number = 8;
			var longitude:Number = long2tile(rawData.geometry.coordinates[0], zoom);
			var latitude:Number = lat2tile(rawData.geometry.coordinates[1], zoom);

			var map:ImageLoader = new ImageLoader();
			map.source = "http://a.tile.openstreetmap.org/" + zoom + "/" + longitude + "/" + latitude + ".png";
			map.width = map.height = 256;
			this.addChild(map);

			/*
			 The following layout allows us to have a 2 columns grid with a nice separation between all elements.
			 */
			var layoutForSummaryTable:TiledRowsLayout = new TiledRowsLayout();
			layoutForSummaryTable.requestedColumnCount = 2;
			layoutForSummaryTable.distributeWidths = true;
			layoutForSummaryTable.useSquareTiles = false;
			layoutForSummaryTable.padding = 20;
			layoutForSummaryTable.verticalGap = 20;
			layoutForSummaryTable.tileHorizontalAlign = HorizontalAlign.LEFT;

			var summaryTable:LayoutGroup = new LayoutGroup();
			summaryTable.layoutData = new VerticalLayoutData(100, NaN);
			summaryTable.layout = layoutForSummaryTable
			this.addChild(summaryTable);

			/*
			 The following labels are added directly to the LayoutGroup that has the tiled layout.
			 Small tweaks were made to ensure the labels always contain useful information.
			 */
			var dateLabel:Label = new Label();
			dateLabel.text = "Date:";
			summaryTable.addChild(dateLabel);

			var dateValueLabel:Label = new Label();
			dateValueLabel.text = new Date(Number(rawData.properties.time)).toLocaleDateString();
			summaryTable.addChild(dateValueLabel);

			var timeLabel:Label = new Label();
			timeLabel.text = "Time:";
			summaryTable.addChild(timeLabel);

			var timeValueLabel:Label = new Label();
			timeValueLabel.text = new Date(Number(rawData.properties.time)).toLocaleTimeString();
			summaryTable.addChild(timeValueLabel);

			var magnitudeLabel:Label = new Label();
			magnitudeLabel.text = "Magnitude:";
			summaryTable.addChild(magnitudeLabel);

			var magnitudeValueLabel:Label = new Label();
			magnitudeValueLabel.text = rawData.properties.mag;
			summaryTable.addChild(magnitudeValueLabel);

			var significanceLabel:Label = new Label();
			significanceLabel.text = "Significance:";
			summaryTable.addChild(significanceLabel);

			var significanceValueLabel:Label = new Label();
			significanceValueLabel.text = rawData.properties.sig + "/1000";
			summaryTable.addChild(significanceValueLabel);

			var feltLabel:Label = new Label();
			feltLabel.text = "Felt Reports:";
			summaryTable.addChild(feltLabel);

			var feltValueLabel:Label = new Label();
			if (rawData.properties.felt == null) {
				feltValueLabel.text = "No reports yet."
			} else {
				feltValueLabel.text = rawData.properties.felt;
			}
			summaryTable.addChild(feltValueLabel);

			var tsunamiLabel:Label = new Label();
			tsunamiLabel.text = "Tsunami Alert:";
			summaryTable.addChild(tsunamiLabel);

			var tsunamiValueLabel:Label = new Label();
			if (rawData.properties.tsunami == 1) {
				tsunamiValueLabel.text = "Yes";
			} else {
				tsunamiValueLabel.text = "No";
			}
			summaryTable.addChild(tsunamiValueLabel);

		}

		/*
		 long2tile and lat2tile functions were taken from the OSM wiki at:
		 https://wiki.openstreetmap.org/wiki/Slippy_map_tilenames
		 */
		private function long2tile(lon:Number, zoom:Number):Number
		{
			return (Math.floor((lon + 180) / 360 * Math.pow(2, zoom)));
		}

		private function lat2tile(lat:Number, zoom:Number):Number
		{
			return (Math.floor((1 - Math.log(Math.tan(lat * Math.PI / 180) + 1 / Math.cos(lat * Math.PI / 180)) / Math.PI) / 2 * Math.pow(2, zoom)));
		}

		private function goBack():void
		{
			this.dispatchEventWith(starling.events.Event.COMPLETE);
		}

	}
}