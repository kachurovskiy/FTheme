package com.fTheme.util
{
public class ColorUtil
{
	
	private static const CODE_0:int = "0".charCodeAt(0);
	private static const CODE_9:int = "9".charCodeAt(0);
	private static const CODE_A:int = "a".charCodeAt(0);
	private static const CODE_F:int = "f".charCodeAt(0);
	
	public static function stringToUint(string:String):uint
	{
		if (!string)
			return 0;
		
		string = string.toLowerCase();
		if (string.charAt(0) == "#")
			string = string.substr(1);
		
		// handle #CCC
		if (string.length == 3)
			string = string.charAt(0) + string.charAt(0) + 
				string.charAt(1) + string.charAt(1) +
				string.charAt(2) + string.charAt(2); // can be optimized
		
		return uint(parseInt(string, 16));
	}
	
}
}