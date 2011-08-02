package com.fTheme.look
{
import com.fTheme.util.ColorUtil;

/**
 * Single color customization property that is used e.g. for <code>color</code>,
 * <code>errorColor</code> or any other single-color style.
 */
public class ColorProperty extends LookProperty
{
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------

	public function ColorProperty(name:String, defaultValue:String)
	{
		super(name, defaultValue);
	}
	
	//--------------------------------------------------------------------------
	//
	//  Overriden methods
	//
	//--------------------------------------------------------------------------

	/**
	 * Parses string representation of color into <code>uint</code>.
	 * 
	 * @param string E.g. "0xFFCC00", "#1140FF", "" or null.
	 * 
	 * @return Color value in <code>uint</code>, 0 if none. 
	 */
	override protected function parseValue(string:String):*
	{
		return ColorUtil.stringToUint(string);
	}
	
}
}