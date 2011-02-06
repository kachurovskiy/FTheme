package com.fTheme.look
{
import mx.core.IMXMLObject;

/**
 * Set default property to <code>nameValueMap</code> so that <code>Look</code> could be
 * initialized in MXML via passing Object as it's child. 
 */
[DefaultProperty("nameValueMap")]

/**
 * Describes look and feel of the application. Can be applied via look manager.
 * Contains pre-loaded assets if they are used in the look. 
 * 
 * @see LookManager
 */
public class Look implements IMXMLObject
{
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------

	/**
	 * Constructor.
	 */
	public function Look(name:String = null)
	{
		this.name = name;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Variables
	//
	//--------------------------------------------------------------------------

	[Bindable]
	public var name:String;

	public var assetMap:Object /* of String -> Class */;
	
	public var propertyValues:Array /* of PropertyValue */ = [];
	
	/**
	 * Array of authors. Can be null.
	 */
	public var authors:Vector.<Author>;
	
	/**
	 * Array of licenses. Can be null.
	 */
	public var licenses:Vector.<License>;
	
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  nameValueMap
	//----------------------------------

	/**
	 * Fills <code>lookPropertyValues</code> using given object
	 * properties and their values.
	 */
	public function set nameValueMap(value:Object):void
	{
		if (!value)
			return;
		
		propertyValues = [];
		for (var name:String in value)
		{
			propertyValues.push(new PropertyValue(name, value[name]));
		}
	}
	
	//----------------------------------
	//  usesBitmaps
	//----------------------------------

	public function get usesBitmaps():Boolean
	{
		var n:int = propertyValues.length;
		for (var i:int = 0; i < n; i++)
		{
			var value:String = PropertyValue(propertyValues[i]).value;
			if (value && value.indexOf("bitmap ") == 0)
				return true;
		}
		return false;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Methods: implementation of IMXMLObject
	//
	//--------------------------------------------------------------------------

	public function initialized(document:Object, id:String):void
	{
	}
}
}