package com.fTheme.controller.look
{
import com.fTheme.controller.util.StrokeUtil;

import mx.graphics.IStroke;
import mx.graphics.SolidColorStroke;

/**
 * Converts text style value to <code>IStroke</code>.
 */
public class StrokeProperty extends LookProperty
{
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------

	public function StrokeProperty(name:String, defaultValue:String)
	{
		super(name, defaultValue);
	}
	
	//--------------------------------------------------------------------------
	//
	//  Overriden methods
	//
	//--------------------------------------------------------------------------

	override protected function parseValue(string:String):*
	{
		return StrokeUtil.stringToStroke(string);
	}
	
	override protected function applyValue(object:*):void
	{
		super.applyValue(object);
		
		// allow to use simply the stroke color by addind
		// "someStrokeColor" uint style in addition to "someStroke" IStroke.
		var stroke:SolidColorStroke = object as SolidColorStroke;
		var styleName:String;
		var alphaStyleName:String;
		if (name == "borderStroke")
		{
			styleName = "borderColor";
			alphaStyleName = "borderAlpha";
		}
		else
		{
			styleName = name + "Color";
			alphaStyleName = name + "Alpha";
		}
		global.setStyle(styleName, stroke ? stroke.color : undefined); 
		global.setStyle(alphaStyleName, stroke ? stroke.alpha : undefined);
	}
	
}
}