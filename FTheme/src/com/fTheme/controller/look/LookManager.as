package com.fTheme.controller.look
{
import mx.styles.IStyleManager2;
import mx.styles.StyleManager;

/**
 * Applies customization to the whole application based on plain text 
 * customization property values.
 */
public class LookManager
{
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------

	public function LookManager()
	{
		super();
		
		addProperty(new ColorArrayProperty("alternatingItemColors", ""));
		
		addProperty(new ColorProperty("color", "0x000000"));
		addProperty(new ColorProperty("errorColor", "0xCC0000"));
		
		addProperty(new FillProperty("applicationFill", "0xFFFFFF"));
		
		addProperty(new FillProperty("panelFill", "0xFFFFFF"));
		addProperty(new StrokeProperty("panelStroke", "0x888888 alpha 0.5"));
		addProperty(new NumberProperty("panelCornerRadius", "0"));
		addProperty(new FillProperty("titlebarFill", "0xE2E2E2 0xD9D9D9"));
		addProperty(new StrokeProperty("titlebarStroke", "0xC0C0C0"));
		addProperty(new ColorProperty("titlebarColor", "0x000000"));
		
		addProperty(new FillProperty("contentFill", "0xFFFFFF"));
		addProperty(new StrokeProperty("contentStroke", "0x888888"));
		addProperty(new NumberProperty("contentCornerRadius", "0"));
		
		addProperty(new ColorProperty("borderColor", "0x888888"));
		addProperty(new StrokeProperty("borderStroke", "0x888888"));
		
		addProperty(new FillProperty("buttonUpFill", 
			"0xFFFFFF 0xF3F3F3 ratio 0.5 0xEAEAEA ratio 0.51 0xD3D3D3 rotation 90"));
		addProperty(new FillProperty("buttonOverFill", 
			"0xD0D1D1 0xC7C9C9 ratio 0.5 0xB5B6B7 ratio 0.51 0xA4A5A6 rotation 90"));
		addProperty(new FillProperty("buttonDownFill",
			"0xBCBCBC 0xB5B6B7 ratio 0.5 0xAAAAAB ratio 0.51 0x9C9E9F rotation 90"));
		addProperty(new FillProperty("buttonSelectedFill",
			"0xBCBCBC 0xB5B6B7 ratio 0.5 0xAAAAAB ratio 0.51 0x9C9E9F rotation 90"));
		addProperty(new FillProperty("buttonDisabledFill", 
			"0xFFFFFF 0xFAFAFA ratio 0.5 0xF5F5F5 ratio 0.51 0xEAEAEA rotation 90"));
		addProperty(new StrokeProperty("buttonStroke", "0x444444"));
		addProperty(new NumberProperty("buttonCornerRadius", "3"));
		addProperty(new NumberProperty("buttonMinWidth", "21"));
		addProperty(new NumberProperty("buttonMinHeight", "21"));
		
		addProperty(new NumberProperty("checkBoxSize", "13"));
		
		addProperty(new NumberProperty("radioButtonSize", "13"));
		addProperty(new NumberProperty("radioButtonDotSize", "5"));
		
		addProperty(new StrokeProperty("highlightStroke", "0xFFFFFF alpha 0.2"));
		
		addProperty(new FillProperty("toolbarFill", "0xE0E0E0 0xDADADA"));
		addProperty(new ColorProperty("toolbarColor", "0xFFFFFF"));
		addProperty(new StrokeProperty("toolbarStroke", "0xC0C0C0"));
		addProperty(new FillProperty("toolbarButtonUpFill", "0xFFFFFF alpha 0"));
		addProperty(new FillProperty("toolbarButtonOverFill", "0xFFCC00"));
		addProperty(new FillProperty("toolbarButtonDownFill", "0x00CCFF"));
		addProperty(new FillProperty("toolbarButtonDisabledFill", "0xFFFFFF alpha 0.2"));
		
		addProperty(new FillProperty("controlbarFill", "0xDADADA 0xC5C5C5"));
		addProperty(new StrokeProperty("controlbarStroke", "0xC0C0C0"));
		addProperty(new ColorProperty("controlbarColor", "0x000000"));
		
		addProperty(new FillProperty("inputFill", "0xFFFFFF"));
		addProperty(new StrokeProperty("inputStroke", "0x000000"));
		addProperty(new NumberProperty("inputCornerRadius", "0"));
		
		addProperty(new FillProperty("hScrollBarTrackFill", "0xCACACA"));
		addProperty(new FillProperty("vScrollBarTrackFill", "0xCACACA"));
		addProperty(new FillProperty("hScrollBarThumbUpFill", "0xFAFAFA 0xF0F0F0 rotation 90"));
		addProperty(new FillProperty("hScrollBarThumbOverFill", "0xC7C7C7 0xB2B2B2 rotation 90"));
		addProperty(new FillProperty("hScrollBarThumbDownFill", "0xBBBBBB 0x8B8B8B rotation 90"));
		addProperty(new FillProperty("vScrollBarThumbUpFill", "0xFAFAFA 0xF0F0F0 rotation 90"));
		addProperty(new FillProperty("vScrollBarThumbOverFill", "0xC7C7C7 0xB2B2B2 rotation 90"));
		addProperty(new FillProperty("vScrollBarThumbDownFill", "0xBBBBBB 0x8B8B8B rotation 90"));
		addProperty(new NumberProperty("scrollBarButtonSize", "17"));
		addProperty(new NumberProperty("scrollBarThumbMinSize", "17"));
		addProperty(new NumberProperty("scrollBarSize", "14"));
		addProperty(new NumberProperty("scrollBarCornerRadius", "0"));
		addProperty(new StrokeProperty("scrollBarStroke", "0x686868"));
		
		addProperty(new FillProperty("sliderTrackFill", "0xCACACA"));
		addProperty(new StrokeProperty("sliderTrackStroke", "0x686868"));
		addProperty(new NumberProperty("sliderTrackSize", "6"));
		addProperty(new NumberProperty("sliderTrackCornerRadius", "3"));
		addProperty(new NumberProperty("sliderThumbSize", "11"));
		
		addProperty(new ColorProperty("symbolColor", "0x444444"));
		addProperty(new FillProperty("symbolFill", "0x444444"));
		
		// set all properties to their default values by passing empty customization
		applyLook(new Look("Default"));
	}
	
	//--------------------------------------------------------------------------
	//
	//  Variables
	//
	//--------------------------------------------------------------------------

	private var properties:Vector.<LookProperty> = new Vector.<LookProperty>();
	
	private var propertyMap:Object = {};
	
	private var styleManager:IStyleManager2 = StyleManager.getStyleManager(null);
	
	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------
	
	private function addProperty(property:LookProperty):void
	{
		if (propertyMap[property.name])
			throw new Error("Property " + property.name + " is already added");
		
		properties.push(property);
		propertyMap[property.name] = property;
	}
	
	public function applyLook(customization:Look):void
	{
		var array:Array = customization.customizationPropertyValues;
		var n:int = array.length;
		var appliedProperties:Object = {};
		var i:int;
		var property:LookProperty;
		for (i = 0; i < n; i++)
		{
			var value:PropertyValue = array[i];
			property = propertyMap[value.name];
			if (!property)
			{
				trace("Property " + value.name + " not found");
				continue;
			}
			
			appliedProperties[value.name] = true;
			property.value = value.value;
		}
		
		n = properties.length;
		for (i = 0; i < n; i++)
		{
			property = properties[i];
			if (appliedProperties[property.name])
				continue;
			
			property.value = property.defaultValue;
		}
		
		styleManager.setStyleDeclaration("global", styleManager.getStyleDeclaration("global"), true);
	}
	
	public function destroy():void
	{
	}
	
}
}