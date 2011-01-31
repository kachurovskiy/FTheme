package com.fTheme.controller.look
{
public class NumberProperty extends LookProperty
{
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------

	public function NumberProperty(name:String, defaultValue:String)
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
		var number:Number = Number(string);
		return isNaN(number) ? 0 : number;
	}
	
}
}