FTheme
=================

FTheme is the Adobe Flex 4 runtime look & feel customization library. 

Usage
-----

* Download `ftheme.swc` into `libs` folder of your project
* Add `-theme+=libs/ftheme.swc` compiler option
* In `Application` MXML tag add `preinitialize="{new FThemeController()}"`

Advanced usage options
----------------------

Download all from `FThemeSample/looks` and see the `FThemeSample.mxml` code:

	<s:Application xmlns:fx="http://ns.adobe.com/mxml/2009" 
		xmlns:s="library://ns.adobe.com/flex/spark" 
		xmlns:mx="library://ns.adobe.com/flex/mx" 
		xmlns:selector="com.fTheme.view.selector.*"
		xmlns:look="com.fTheme.controller.look.*"
		preinitialize="preinit();" xmlns:local="*">
		
		<fx:Script>
		<![CDATA[
			import com.fTheme.controller.FThemeController;
			import com.fTheme.controller.FThemeOptions;
			
			import mx.controls.Alert;
			
			/**
			 * Make sure to call this on "preinitialize".
			 */
			private function preinit():void
			{
				var controller:FThemeController = 
					new FThemeController(new FThemeOptions("lookLinks.xml"));
				controller.addEventListener(ErrorEvent.ERROR, controller_errorHandler);
			}
			
			private function controller_errorHandler(event:ErrorEvent):void
			{
				Alert.show(event.text, "FTheme error");
			}
			
		]]>
		</fx:Script>
		
		<selector:LookSelector/>
		
	</s:Application>