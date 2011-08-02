package com.fTheme.look
{
import flash.events.EventDispatcher;

/**
 * Dispatched by load action to show progress in item renderers.
 */
[Event(name="progress", type="flash.events.ProgressEvent")]

[DefaultProperty("look")]
/**
 * Contains information about where the look files can be obtained. Looks are usually
 * loaded on demand.
 * 
 * <p>Look list item renderer usually checks <code>status</code> property for
 * look status.</p>
 */
public class LookLink extends EventDispatcher
{
	
	//--------------------------------------------------------------------------
	//
	//  Static methods
	//
	//--------------------------------------------------------------------------

	/**
	 * Creates new look link from it's XML description. e.g. 
	 * <code>&lt;lookLink name="Plastic"/&gt;</code>.
	 */
	public static function fromXML(lookLinkXML:XML):LookLink
	{
		var lookLink:LookLink = new LookLink(lookLinkXML.@name);
		if (lookLinkXML.@txtFileURL.length() > 0)
			lookLink.txtFileURL = lookLinkXML.@txtFileURL;
		if (lookLinkXML.@zipFileURL.length() > 0)
			lookLink.zipFileURL = lookLinkXML.@zipFileURL;
		return lookLink;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------

	/**
	 * Constructor.
	 */
	public function LookLink(name:String = null)
	{
		super();
		
		this.name = name;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Variables
	//
	//--------------------------------------------------------------------------

	[Bindable]
	/**
	 * Name of the look to display in look selector.
	 */
	public var name:String;
	
	[Bindable]
	public var errorText:String;
	
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------
	
	//--------------------------------------
	//  status
	//--------------------------------------

	private var _status:String = LookLinkStatus.NOT_LOADED;

	[Bindable("statusChange")]
	public function get status():String 
	{
		return _status;
	}

	public function set status(value:String):void
	{
		if (_status == value)
			return;
		
		_status = value;
		dispatchEvent(new Event("statusChange"));
	}

	//--------------------------------------
	//  txtFileURL
	//--------------------------------------

	private var _txtFileURL:String;
	
	/**
	 * URL to the file with text look definition.
	 */
	public function get txtFileURL():String 
	{
		return _txtFileURL ? _txtFileURL : name + ".txt";
	}

	public function set txtFileURL(value:String):void
	{
		if (_txtFileURL == value)
			return;
		
		_txtFileURL = value;
	}
	
	//--------------------------------------
	//  zipFileURL
	//--------------------------------------

	private var _zipFileURL:String;
	
	/**
	 * URL to ZIP archive with bitmaps that are used in the look. Leave as null
	 * to use <code>txtFileURL</code> with "zip" instead of "txt" extension.
	 */
	public function get zipFileURL():String 
	{
		if (_zipFileURL)
			return _zipFileURL;
		
		if (_txtFileURL)
		{
			var lastTXTIndex:int = _txtFileURL.lastIndexOf(".txt");
			if (lastTXTIndex > 0)
				return _txtFileURL.substring(0, lastTXTIndex) + ".zip" + 
					_txtFileURL.substring(lastTXTIndex + 4);
		}
		
		return name + ".zip";
	}

	public function set zipFileURL(value:String):void
	{
		if (_zipFileURL == value)
			return;
		
		_zipFileURL = value;
	}

	//--------------------------------------
	//  look
	//--------------------------------------

	private var _look:Look;

	[Bindable("lookChange")]
	public function get look():Look 
	{
		return _look;
	}

	public function set look(value:Look):void
	{
		if (_look == value)
			return;
		
		_look = value;
		if (_look)
		{
			name = _look.name;
			status = LookLinkStatus.LOADED;
		}
		dispatchEvent(new Event("lookChange"));
	}

}
}