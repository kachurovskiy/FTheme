package com.fTheme.controller.look
{
import mx.styles.CSSStyleDeclaration;
import mx.styles.IStyleManager2;
import mx.styles.StyleManager;

/**
 * Represents one customization (style) property e.g. 
 * <code>errorColor</code> or <code>applicationFill</code>.
 * 
 * <p>Child classes contain logic of parsing text value into strong-typed style value 
 * (e.g. <code>errorColor</code> into <code>uint</code> and <code>applicationFill</code> 
 * into <code>IFill</code>).</p>
 */
public class LookProperty
{
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------

	public function LookProperty(name:String, defaultValue:String)
	{
		super();
		
		_name = name;
		_defaultValue = defaultValue;
		
		styleManager = StyleManager.getStyleManager(null);
		global = styleManager.getStyleDeclaration("global");
	}
	
	//--------------------------------------------------------------------------
	//
	//  Variables
	//
	//--------------------------------------------------------------------------

	protected var styleManager:IStyleManager2;
	
	protected var global:CSSStyleDeclaration;
	
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  name
	//----------------------------------

	private var _name:String;
	
	/**
	 * Name of the style e.g. <code>color</code>, <code>errorColor</code> or 
	 * <code>buttonUpFill</code>.
	 */
	public function get name():String
	{
		return _name;
	}
	
	//----------------------------------
	//  defaultValue
	//----------------------------------
	
	private var _defaultValue:String;

	/**
	 * Is used to initialize application styles on start and to use as a value
	 * when some customization does not provide value for this property.
	 */
	public function get defaultValue():String
	{
		return _defaultValue;
	}
	
	//--------------------------------------
	//  value
	//--------------------------------------

	private var _value:String;

	public function get value():String 
	{
		return _value;
	}

	public function set value(value:String):void
	{
		if (_value == value)
			return;
		
		_value = value;
		var parsedValue:* = parseValue(_value);
		applyValue(parsedValue);
	}
	
	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------

	/**
	 * Parses text representation of style value into a strong-typed value e.g.
	 * parses "0xFFCC00 0x00CC00" into <code>LinearGradient</code> or "0xFFCC00"
	 * into <code>uint</code> (depends on child classes overrides).
	 * 
	 * <p>By default the string is returned unchanged.</p>
	 */
	protected function parseValue(string:String):*
	{
		return string;
	}
	
	/**
	 * Applies given style value to the applicatiopn styles. Sometimes it is 
	 * necessary to set style value not only to <code>global</code>
	 * but to other style declarations too.
	 */
	protected function applyValue(object:*):void
	{
		global.setStyle(_name, object);
	}
	
}
}