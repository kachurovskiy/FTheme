package com.fTheme.components
{
import flash.events.Event;

import spark.components.SkinnableContainer;
import spark.layouts.HorizontalAlign;
import spark.layouts.HorizontalLayout;
import spark.layouts.supportClasses.LayoutBase;

public class Toolbar extends SkinnableContainer
{
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------

	public function Toolbar()
	{
		super();
		
		percentWidth = 100;
		
		var horizontalLayout:HorizontalLayout = new HorizontalLayout();
		horizontalLayout.paddingBottom = 5;
		horizontalLayout.paddingRight = 5;
		horizontalLayout.paddingTop = 5;
		horizontalLayout.paddingLeft= 5;
		_skinLayout = horizontalLayout;
		
		setStyle("skinClass", ToolbarSkin);
	}
	
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------
	
	//--------------------------------------
	//  skinLayout
	//--------------------------------------

	private var _skinLayout:LayoutBase;

	[Bindable("skinLayoutChange")]
	public function get skinLayout():LayoutBase 
	{
		return _skinLayout;
	}

	public function set skinLayout(value:LayoutBase):void
	{
		if (_skinLayout == value)
			return;
		
		_skinLayout = value;
		if (contentGroup)
			contentGroup.layout = _skinLayout;
		dispatchEvent(new Event("skinLayoutChange"));
	}

	//--------------------------------------------------------------------------
	//
	//  Overriden methods
	//
	//--------------------------------------------------------------------------

	override protected function partAdded(partName:String, instance:Object):void
	{
		super.partAdded(partName, instance);
		
		if (instance == contentGroup)
		{
			if (_skinLayout)
				contentGroup.layout = _skinLayout;
		}
	}

}
}