package com.fTheme.controller.look
{
import mx.core.IMXMLObject;

[DefaultProperty("data")]
public class Look implements IMXMLObject
{
	public function Look(name:String = null, assetFileName:String = null)
	{
		this.name = name;
		this.assetFileName = assetFileName;
	}
	
	public var name:String;
	
	public var assetFileName:String;
	
	public var customizationPropertyValues:Array = [];
	
	/**
	 * Fills <code>customizationPropertyValues</code> using given object
	 * properties and their values.
	 */
	public function set data(value:Object):void
	{
		if (!value)
			return;
		
		customizationPropertyValues = [];
		for (var name:String in value)
		{
			var customizationPropertyValue:PropertyValue = new
				PropertyValue(name, value[name]);
			customizationPropertyValues.push(customizationPropertyValue);
		}
	}
	
	public function initialized(document:Object, id:String):void
	{
	}
}
}