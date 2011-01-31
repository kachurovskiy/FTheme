package com.fThemeSample.controller
{
import com.fTheme.controller.asset.AssetManager;
import com.fThemeSample.model.Model;
import com.fTheme.controller.FThemeController;

/**
 * Global applicaion controller. Initializes (and can propertly destroy in future
 * in needed) various managers and sub-controllers. Instantianes model (if needed). 
 */
public class Controller
{
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------

	public function Controller()
	{
		initialize();
	}
	
	//--------------------------------------------------------------------------
	//
	//  Variables
	//
	//--------------------------------------------------------------------------

	private var model:Model;
	
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  fThemeController
	//----------------------------------

	private var _fThemeController:FThemeController;

	[Bindable("__NoChangeEvent__")]
	public function get fThemeController():FThemeController
	{
		return _fThemeController;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------

	private function initialize():void
	{
		model = new Model(this);
		
		_fThemeController = new FThemeController();
	}
	
	private function destroy():void
	{
		_fThemeController.destroy();
		_fThemeController = null;
		
		model.destroy();
		model = null;
	}
	
}
}