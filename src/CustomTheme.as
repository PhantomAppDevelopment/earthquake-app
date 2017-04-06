package
{
	import feathers.controls.Button;
	import feathers.controls.Header;
	import feathers.controls.ImageLoader;
	import feathers.controls.Label;
	import feathers.controls.List;
	import feathers.controls.PanelScreen;
	import feathers.controls.text.TextFieldTextRenderer;
	import feathers.core.FeathersControl;
	import feathers.core.ITextRenderer;
	import feathers.layout.HorizontalAlign;
	import feathers.layout.RelativePosition;
	import feathers.layout.VerticalAlign;
	import feathers.themes.StyleNameFunctionTheme;

	import starling.display.Quad;
	import starling.text.TextFormat;

	public class CustomTheme extends StyleNameFunctionTheme
	{
		/*
		 To use a custom font you must provide its file path and give it a name to use.
		 "MyFont" gets globally registered so it can be used here and in other parts of this app.
		 */
		[Embed(source="assets/font.ttf", fontFamily="MyFont", fontWeight="normal", fontStyle="normal", mimeType="application/x-font", embedAsCFF="false")]
		private static const MY_FONT:Class;

		public function CustomTheme()
		{
			super();
			this.initialize();
		}

		/*
		 The following 3 methods are required to set up a Custom Theme.
		 */
		private function initialize():void
		{
			this.initializeGlobals();
			this.initializeStyleProviders();
		}

		private function initializeGlobals():void
		{
			/*
			 This app uses TextFieldTextRenderer for its HTML text capabilities.
			 */
			FeathersControl.defaultTextRendererFactory = function ():ITextRenderer
			{
				var renderer:TextFieldTextRenderer = new TextFieldTextRenderer();
				renderer.isHTML = true;
				return renderer;
			}
		}

		/*
		 This method is where all of our custom styles get registered so they can be used in the app.
		 There are 2 types of styles, the default and the custom styles. We separate them for better readibility.
		 */
		private function initializeStyleProviders():void
		{
			this.getStyleProviderForClass(Button).setFunctionForStyleName("horizontal-button", this.setHorizontalButtonStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName("back-button", this.setBackButtonStyles);

			this.getStyleProviderForClass(Header).defaultStyleFunction = this.setHeaderStyles;
			this.getStyleProviderForClass(Label).defaultStyleFunction = this.setLabelStyles;
			this.getStyleProviderForClass(List).defaultStyleFunction = this.setListStyles;
			this.getStyleProviderForClass(PanelScreen).defaultStyleFunction = this.setPanelScreenStyles;
		}

		//-------------------------
		// Button
		//-------------------------

		private function setBackButtonStyles(button:Button):void
		{
			var backButtonIcon:ImageLoader = new ImageLoader();
			backButtonIcon.source = "assets/icons/back.png";
			backButtonIcon.height = backButtonIcon.width = 25;

			button.defaultIcon = backButtonIcon;

			var quad:Quad = new Quad(45, 45, 0xFFFFFF);
			quad.alpha = .3;

			button.downSkin = quad;
			button.height = button.width = 45;
		}

		private function setHorizontalButtonStyles(button:Button):void
		{
			button.defaultSkin = new Quad(3, 3, 0x455A64);
			button.downSkin = new Quad(3, 3, 0x263238);
			button.iconPosition = RelativePosition.LEFT;
			button.horizontalAlign = HorizontalAlign.LEFT;
			button.verticalAlign = VerticalAlign.MIDDLE;
			button.paddingLeft = 20;
			button.gap = 20;
			button.fontStyles = new TextFormat("MyFont", 30, 0xFFFFFF, "left");
		}

		//-------------------------
		// Header
		//-------------------------

		private function setHeaderStyles(header:Header):void
		{
			var skin:Quad = new Quad(3, 50, 0x607D8B);
			header.backgroundSkin = skin;
			header.fontStyles = new TextFormat("MyFont", 18, 0xFFFFFF, "left");
			header.gap = 5;
			header.paddingLeft = header.paddingRight = 2;
		}

		//-------------------------
		// Label
		//-------------------------

		private function setLabelStyles(label:Label):void
		{
			label.fontStyles = new TextFormat("_sans", 14, 0xFFFFFFF, "left");
		}

		//-------------------------
		// List
		//-------------------------

		private function setListStyles(list:List):void
		{
			list.backgroundSkin = new Quad(3, 3, 0x455A64);
			list.hasElasticEdges = false;
		}

		//-------------------------
		// PanelScreen
		//-------------------------

		private function setPanelScreenStyles(screen:PanelScreen):void
		{
			screen.backgroundSkin = new Quad(3, 3, 0x455A64);
			screen.hasElasticEdges = false;
		}

	}
}