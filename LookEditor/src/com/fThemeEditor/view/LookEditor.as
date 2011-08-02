package com.fThemeEditor.view
{
import com.fTheme.FThemeController;
import com.fTheme.look.LookManager;
import com.fTheme.look.LookProperty;

import flash.events.Event;

import mx.collections.ArrayCollection;
import mx.collections.Sort;
import mx.collections.SortField;
import mx.core.UIComponent;

import spark.components.BorderContainer;
import spark.components.Group;
import spark.components.Label;
import spark.components.List;
import spark.components.TabBar;
import spark.components.supportClasses.SkinnableComponent;

public class LookEditor extends SkinnableComponent
{
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------

	public function LookEditor()
	{
		super();
		
		setStyle("skinClass", LookEditorSkin);
		
		var propertiesVector:Vector.<LookProperty> = lookManager.properties;
		var n:int = propertiesVector.length;
		var array:Array = [];
		for (var i:int = 0; i < n; i++)
		{
			array.push(propertiesVector[i]);
		}
		properties = new ArrayCollection(array);
		var sort:Sort = new Sort();
		sort.fields = [ new SortField("name") ];
		properties.sort = sort;
		properties.refresh();
	}
	
	//--------------------------------------------------------------------------
	//
	//  Variables
	//
	//--------------------------------------------------------------------------

	[SkinPart]
	public var propertyList:List;
	
	[SkinPart]
	public var editorView:UIComponent;
	
	[SkinPart]
	public var editorContainer:BorderContainer;
	
	[SkinPart]
	public var editorsTabBar:TabBar;
	
	[SkinPart]
	public var propertyNameLabel:Label;
	
	private var lookManager:LookManager = FThemeController.instance.lookManager;
	
	private var properties:ArrayCollection;
	
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------
	
	//--------------------------------------
	//  lookProperty
	//--------------------------------------

	private var _lookProperty:LookProperty;

	[Bindable("lookPropertyChange")]
	public function get lookProperty():LookProperty
	{
		return _lookProperty;
	}

	public function set lookProperty(value:LookProperty):void
	{
		if (_lookProperty == value)
			return;
		
		_lookProperty = value;
		commitEditor();
		dispatchEvent(new Event("lookPropertyChange"));
	}
	
	//--------------------------------------------------------------------------
	//
	//  Overriden methods
	//
	//--------------------------------------------------------------------------
	
	override protected function partAdded(partName:String, instance:Object):void
	{
		super.partAdded(partName, instance);
		
		if (instance == propertyList)
		{
			propertyList.dataProvider = properties;
		}
		else if (instance == editorContainer || instance == editorView)
		{
			commitEditor();
		}
	}
	
	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------

	private function commitEditor():void
	{
		if (!editorContainer || !editorView)
			return;

		editorContainer.includeInLayout = Boolean(_lookProperty);
		editorContainer.visible = Boolean(_lookProperty);
		if (_lookProperty)
		{
			editorContainer.removeAllElements();
		}
		else
		{
			
		}
	}
	
}
}