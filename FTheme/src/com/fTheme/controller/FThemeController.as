package com.fTheme.controller
{
import com.fTheme.controller.asset.AssetManager;
import com.fTheme.controller.look.LookManager;

import flash.display.Stage;
import flash.events.ErrorEvent;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.utils.setTimeout;

import mx.controls.Alert;
import mx.core.mx_internal;
import mx.managers.ISystemManager;
import mx.managers.SystemManager;

use namespace mx_internal;

/**
 * Dispatched when FTheme finishes it's initialization. 
 */
[Event(name="init", type="flash.events.Event")]
/**
 * Dispatched when initalization error occur.
 */
[Event(name="error", type="flash.events.ErrorEvent")]

/**
 * Global customization controller. Initializes (and can propertly destroy in future
 * in needed) various managers and sub-controllers. 
 */
public class FThemeController extends EventDispatcher
{
	
	//--------------------------------------------------------------------------
	//
	//  Static properties
	//
	//--------------------------------------------------------------------------
	
	//--------------------------------------
	//  instance
	//--------------------------------------

	private static var _instance:FThemeController;

	/**
	 * Returns the only instance of <code>FThemeController</code>. If it does not
	 * exist then it is created.
	 */
	public static function get instance():FThemeController 
	{
		if (!_instance)
			new FThemeController();
		
		return _instance;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Static methods
	//
	//--------------------------------------------------------------------------
	
	public static function getDefaultOptions():FThemeOptions
	{
		// find FlashVars. Since app is not even added to stage it's not straightforward 
		var stage:Stage;
		for (var p:* in SystemManager.allSystemManagers)
		{
			var sm:ISystemManager = p as ISystemManager;
			stage = sm.stage;
			if (stage)
				break;
		}
		var flashVars:Object = stage.root.loaderInfo.parameters;
		
		var options:FThemeOptions = new FThemeOptions();
		
		// check if we should allow default look
		var showDefaultLook:String = flashVars.showDefaultLook;
		if (showDefaultLook == "false")
			options.showDefaultLook = false;
		
		if (flashVars.lookLinkNames)
			options.lookLinkNames = decodeURIComponent(flashVars.lookLinkNames).split(",");
		if (flashVars.lookLinksXMLURL)
			options.lookLinksXMLURL = flashVars.lookLinksXMLURL;
		else // by default load lookLinks.xml from the same folder as SWF
			options.lookLinksXMLURL = "lookLinks.xml";
		
		return options;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------

	/**
	 * Constructor.
	 */
	public function FThemeController(options:FThemeOptions = null)
	{
		super();
		
		initialize(options);
		
		constructed = true;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Variables
	//
	//--------------------------------------------------------------------------

	private var constructed:Boolean = false;
	
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  options
	//----------------------------------

	private var _options:FThemeOptions;

	[Bindable("__NoChangeEvent__")]
	public function get options():FThemeOptions
	{
		return _options;
	}
	
	//--------------------------------------
	//  assetManager
	//--------------------------------------

	private var _assetManager:AssetManager;

	[Bindable("__NoChangeEvent__")]
	/**
	 * Asset manager stores bitmap assets and provides methods to retrieve and modify assets.
	 */
	public function get assetManager():AssetManager 
	{
		return _assetManager;
	}
	
	//----------------------------------
	//  lookManager
	//----------------------------------

	private var _lookManager:LookManager;
	
	[Bindable("__NoChangeEvent__")]
	/**
	 * Applies customization to the whole application based on plain text 
	 * customization property values.
	 */
	public function get lookManager():LookManager
	{
		return _lookManager;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------

	private function initialize(options:FThemeOptions):void
	{
		if (_instance)
			throw new Error("singleton error");
		_instance = this;
		
		if (!options)
			options = getDefaultOptions();
		_options = options;
		
		_assetManager = new AssetManager();
		
		_lookManager = new LookManager();
		_lookManager.addEventListener(Event.INIT, redispatchHandler);
		_lookManager.addEventListener(ErrorEvent.ERROR, redispatchHandler);
		_lookManager.initialize();
	}
	
	public function destroy():void
	{
		if (!_instance) // already destroyed
			return;
		
		_lookManager.removeEventListener(Event.INIT, redispatchHandler);
		_lookManager.removeEventListener(ErrorEvent.ERROR, redispatchHandler);
		_lookManager.destroy();
		_lookManager = null;
		
		_assetManager.destroy();
		_assetManager = null;
		
		_instance = null;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Event handlers
	//
	//--------------------------------------------------------------------------

	private function redispatchHandler(event:Event):void
	{
		if (!constructed)
		{
			// noone had a chance to subscribe, dispatch a bit later
			setTimeout(redispatchHandler, 0, event);
			return;
		}

		if (!hasEventListener(event.type))
		{
			if (event is ErrorEvent)
				Alert.show(ErrorEvent(event).text, "FTheme error");
			return;
		}
		dispatchEvent(event);
	}
	
}
}