package com.fTheme.controller.look
{
import com.fTheme.controller.util.ColorUtil;

import mx.utils.StringUtil;

public class ColorArrayProperty extends LookProperty
{
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------

	public function ColorArrayProperty(name:String, defaultValue:String)
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
		if (string)
			string = StringUtil.trim(string);
		if (!string)
			return [];
		var array:Array = string.split(/\s/);
		var n:int = array.length;
		for (var i:int = 0; i < n; i++)
		{
			array[i] = ColorUtil.stringToUint(array[i]);
		}
		return array;
	}
	
}
}