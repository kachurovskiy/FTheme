package com.fThemeSample.model
{
import com.fThemeSample.controller.Controller;

/**
 * Application model. Is explicitly created during controller initialization.
 */
public class Model
{
	
	//--------------------------------------------------------------------------
	//
	//  Static properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  instance
	//----------------------------------

	private static var _instance:Model;

	[Bindable("__NoChangeEvent__")]
	public static function get instance():Model
	{
		return _instance;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------

	public function Model(controller:Controller)
	{
		if (_instance)
			throw new Error("Singleton error");
		_instance = this;
		_controller = controller;
		_assets = new Assets();
	}
	
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  controller
	//----------------------------------

	private var _controller:Controller;

	[Bindable("__NoChangeEvent__")]
	public function get controller():Controller
	{
		return _controller;
	}
	
	//----------------------------------
	//  assets
	//----------------------------------

	private var _assets:Assets;

	[Bindable("__NoChangeEvent__")]
	public function get assets():Assets
	{
		return _assets;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------

	public function destroy():void
	{
		_assets = null;
		_controller = null;
		_instance = null;
	}
	
}
}