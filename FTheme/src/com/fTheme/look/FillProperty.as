package com.fTheme.look
{
import com.fTheme.util.FillUtil;

import mx.utils.StringUtil;

/**
 * Converts property text value to <code>IFill</code>.
 */
public class FillProperty extends LookProperty
{
	
	//--------------------------------------------------------------------------
	//
	//  Static methods
	//
	//--------------------------------------------------------------------------

	/**
	 * Checks if given style value describes bitmap fill. Is used by 
	 * <code>LookManager</code> to check if ZIP archive with images
	 * needs to be loaded before applying customization.
	 */
	public static function styleValueIsBitmapFill(string:String):Boolean
	{
		if (!string)
			return false;
		
		return StringUtil.trim(string.toLowerCase()).indexOf("bitmap ") == 0;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------

	public function FillProperty(name:String, defaultValue:String)
	{
		super(name, defaultValue);
	}
	
	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------

	override protected function parseValue(string:String):*
	{
		return FillUtil.stringToFill(string);
	}
	
}
}