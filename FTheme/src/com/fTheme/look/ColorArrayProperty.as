package com.fTheme.look
{
import com.fTheme.util.ColorUtil;

import mx.utils.StringUtil;

public class ColorArrayProperty extends LookProperty
{
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------

	public function ColorArrayProperty(name:String, defaultValue:String, minLength:int = 1,
		maxLength:int = int.MAX_VALUE)
	{
		super(name, defaultValue);
		
		this.minLength = minLength;
		this.maxLength = maxLength;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Variables
	//
	//--------------------------------------------------------------------------

	private var minLength:int;
	
	private var maxLength:int;
	
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
		var i:int;
		for (i = 0; i < n; i++)
		{
			array[i] = ColorUtil.stringToUint(array[i]);
		}
		
		// add colors until minLength
		for (i = n; i < minLength; i++)
		{
			array.push(0x000000);
		}
		// remove colors until maxLength
		for (i = n; i > maxLength; i--)
		{
			array.pop();
		}
		
		return array;
	}
	
}
}