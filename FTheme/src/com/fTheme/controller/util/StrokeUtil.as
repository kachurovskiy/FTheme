package com.fTheme.controller.util
{
import flash.display.CapsStyle;
import flash.display.JointStyle;

import mx.graphics.IStroke;
import mx.graphics.SolidColorStroke;
import mx.utils.StringUtil;

/**
 * Provides various operations on <code>IStroke</code> strokes.
 */
public class StrokeUtil
{
	
	/**
	 * Converts "#FFCC00 alpha 0.5" to <code>IStroke</code>.
	 */
	public static function stringToStroke(string:String):IStroke
	{
		if (!string)
			return null;
		
		string = StringUtil.trim(string);
		var parts:Array = string.split(/\s/); // split by whitespace
		var stroke:SolidColorStroke = new SolidColorStroke();
		// our borders are always 1 pixel and rounded caps looks like a bug
		stroke.caps = CapsStyle.SQUARE; 
		var n:int = parts.length;
		for (var i:int = 0; i < n; i++)
		{
			var part:String = parts[i];
			if (part.charAt(0) == "#" || part.indexOf("0x") == 0)
				stroke.color = ColorUtil.stringToUint(part);
			else if (part == "alpha")
				stroke.alpha = Number(parts[++i]);
		}
		stroke.color = ColorUtil.stringToUint(string);

		return stroke;
	}
	
}
}