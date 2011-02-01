package com.fTheme.controller
{
import com.fTheme.controller.asset.AssetManager;
import com.fTheme.controller.look.LookManager;

import flash.events.EventDispatcher;

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
	//  Constructor
	//
	//--------------------------------------------------------------------------

	/**
	 * Constructor.
	 */
	public function FThemeController()
	{
		super();
		
		initialize();
	}
	
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------
	
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

	private function initialize():void
	{
		if (_instance)
			throw new Error("singleton error");
		_instance = this;
		
		_assetManager = new AssetManager();
		
		_lookManager = new LookManager();
	}
	
	public function destroy():void
	{
		if (!_instance) // already destroyed
			return;
		
		_lookManager.destroy();
		_lookManager = null;
		
		_assetManager.destroy();
		_assetManager = null;
		
		_instance = null;
	}
	
}
}