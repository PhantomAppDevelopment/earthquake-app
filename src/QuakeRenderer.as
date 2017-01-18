package
{
	import feathers.controls.ImageLoader;
	import feathers.controls.Label;
	import feathers.controls.renderers.LayoutGroupListItemRenderer;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	import feathers.utils.touch.TapToSelect;

	import starling.display.Quad;
	import starling.text.TextFormat;

	public class QuakeRenderer extends LayoutGroupListItemRenderer
	{
		private var _quakeLabel:Label;
		private var _magnitudeLabel:Label;
		private var _circle:ImageLoader;
		private var _select:TapToSelect;

		public function QuakeRenderer()
		{
			super();
			this._select = new TapToSelect(this); //This helper allows our ItemRenderer to dispatch the starling.events.Event.CHANGE event.
		}

		/*
		 This is our custom ItemRenderer that will display quick information about all the recent earthquakes.

		 It contains 2 labels and one graphic element that will dynamically change its color depending
		 on the quake magnitude.
		 */
		override protected function initialize():void
		{
			super.initialize();

			this.layout = new AnchorLayout();
			this.height = 80; //Fixed height of 80 device independent units.
			this.isQuickHitAreaEnabled = true; //Improves performance by avoiding unnecessary calculations.
			this.backgroundSkin = new Quad(3, 3, 0x455A64);
			this.backgroundSelectedSkin = new Quad(3, 3, 0x263238);

			/*
			 We load our circle asset into an ImageLoader.
			 It is very important that the asset is white color, since it is the only color capable of being tinted to any other color.
			 */
			_circle = new ImageLoader();
			_circle.source = "assets/circle.png";
			_circle.width = _circle.height = 50;

			_magnitudeLabel = new Label();
			_magnitudeLabel.layoutData = new AnchorLayoutData(NaN, NaN, NaN, 10, NaN, 0);
			_magnitudeLabel.backgroundSkin = _circle;
			_magnitudeLabel.fontStyles = new TextFormat("MyFont", 22, 0xFFFFFF, "center");
			this.addChild(_magnitudeLabel);

			_quakeLabel = new Label();
			_quakeLabel.wordWrap = true;
			_quakeLabel.layoutData = new AnchorLayoutData(5, 5, 5, 75);
			_quakeLabel.fontStyles = new TextFormat("_sans", 14, 0xFFFFFF, "left");
			_quakeLabel.fontStyles.leading = 7;
			this.addChild(_quakeLabel);
		}

		/*
		 The commitData method is called every time the ItemRenderer receives new data.

		 ItemRenderers get recycled to gain maximum performance, ensuring they always have the correct data is
		 done in this method override.
		 */
		override protected function commitData():void
		{
			if (this._data && this._owner) {

				this.backgroundSkin = new Quad(3, 3, 0x455A64); //We reset the background color everytime the data is changed.

				var magnitude:Number = _data.properties.mag;

				/*
				 If the quake magnitude is greater than 6 we tint our circle in a red shade.
				 If the quake magnitude is 4 or less we tint it green.
				 For the other magnitudes (4.1 to 5.9) we tint it orange.
				 */
				if (magnitude >= 6) {
					_circle.color = 0xDD2C00;
				} else if (magnitude <= 4) {
					_circle.color = 0x2E7D32;
				} else {
					_circle.color = 0xFF6D00;
				}

				_magnitudeLabel.text = String(magnitude);

				/*
				 We convert the UNIX timestamp received from the web API into a human readable format.
				 */
				var date:Date = new Date(Number(_data.properties.time));
				_quakeLabel.text = "<b>" + _data.properties.place + "</b>" + "\n" + date.toLocaleDateString() + " @ " + date.toLocaleTimeString();
			} else {
				/*
				 In case there's no new data we set the labels values to an empty string, this is to avoid runtime errors.
				 */
				_magnitudeLabel.text = "";
				_quakeLabel.text = "";
			}
		}

	}
}