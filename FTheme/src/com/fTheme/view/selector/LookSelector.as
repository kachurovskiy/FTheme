package com.fTheme.view.selector
{
import com.fTheme.controller.FThemeController;
import com.fTheme.controller.look.Author;
import com.fTheme.controller.look.License;
import com.fTheme.controller.look.Look;
import com.fTheme.controller.look.LookLink;

import flash.events.Event;

import flashx.textLayout.elements.TextFlow;
import flashx.textLayout.formats.WhiteSpaceCollapse;

import mx.collections.IList;

import spark.components.Group;
import spark.components.List;
import spark.components.RichEditableText;
import spark.components.supportClasses.SkinnableComponent;
import spark.events.IndexChangeEvent;
import spark.utils.TextFlowUtil;

[DefaultProperty("dataProvider")]

/**
 * UI component that allows user to select look and feel, load it and
 * apply.
 */
public class LookSelector extends SkinnableComponent
{
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------

	/**
	 * Constructor.
	 */
	public function LookSelector()
	{
		super();
		
		setStyle("skinClass", LookSelectorSkin);
		
		_look = controller.lookManager.look;
		controller.lookManager.addEventListener("lookChange", lookManager_lookChangeHandler, false, 0, true);
	}
	
	//--------------------------------------------------------------------------
	//
	//  Variables
	//
	//--------------------------------------------------------------------------
	
	[Bindable("__NoChangeEvent__")]
	private var controller:FThemeController = FThemeController.instance;
	
	[SkinPart]
	public var list:List;
	
	[SkinPart]
	public var infoGroup:Group;
	
	[SkinPart]
	public var infoText:RichEditableText;
	
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------
	
	//--------------------------------------
	//  dataProvider
	//--------------------------------------

	private var _dataProvider:IList;

	[Bindable("dataProviderChange")]
	public function get dataProvider():IList 
	{
		return _dataProvider;
	}

	public function set dataProvider(value:IList):void
	{
		if (_dataProvider == value)
			return;
		
		_dataProvider = value;
		updateList();
		dispatchEvent(new Event("dataProviderChange"));
	}
	
	//--------------------------------------
	//  look
	//--------------------------------------

	private var _look:Look;

	private function set look(value:Look):void
	{
		if (_look == value)
			return;
		
		_look = value;
		updateInfo();
		updateList();
	}

	//--------------------------------------------------------------------------
	//
	//  Overriden methods
	//
	//--------------------------------------------------------------------------
	
	override protected function partAdded(partName:String, instance:Object):void
	{
		super.partAdded(partName, instance);
		
		if (instance == list)
		{
			list.labelField = "name";
			list.addEventListener(IndexChangeEvent.CHANGE, list_changeHandler);
			updateList();
		}
		else if (instance == infoText)
		{
			updateInfo();
		}
		else if (instance == infoGroup)
		{
			updateInfo();
		}
	}
	
	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------

	private function updateInfo():void
	{
		if (!infoText || !infoGroup)
			return;
		
		var textFlow:TextFlow;
		if (_look)
		{
			XML.ignoreWhitespace = false;
			var xml:XML = <TextFlow xmlns="http://ns.adobe.com/textLayout/2008"/>;
			var authors:Vector.<Author> = _look.authors;
			var n:int = authors ? authors.length : 0;
			var i:int;
			var paragraph:XML;
			var delimeter:XML = <span xmlns="http://ns.adobe.com/textLayout/2008">, </span>;
			if (n > 0)
			{
				paragraph = <p xmlns="http://ns.adobe.com/textLayout/2008">Authors: </p>;
				for (i = 0; i < n; i++)
				{
					if (i > 0)
						paragraph.appendChild(delimeter.copy());
					paragraph.appendChild(authors[i].toTLFXML());
				}
				xml.appendChild(paragraph);
			}
			var licenses:Vector.<License> = _look.licenses;
			n = licenses ? licenses.length : 0;
			if (n > 0)
			{
				paragraph = <p xmlns="http://ns.adobe.com/textLayout/2008">Licenses: </p>;
				for (i = 0; i < n; i++)
				{
					if (i > 0)
						paragraph.appendChild(delimeter.copy());
					paragraph.appendChild(licenses[i].toTLFXML());
				}
				xml.appendChild(paragraph);
			}
			textFlow = TextFlowUtil.importFromXML(xml, WhiteSpaceCollapse.PRESERVE);
			XML.ignoreWhitespace = true;
		}
		else
		{
			textFlow = new TextFlow();
		}
		infoText.textFlow = textFlow;
		infoGroup.visible = 
		infoGroup.includeInLayout = textFlow.numChildren > 1;
	}
	
	private function updateList():void
	{
		if (!_dataProvider || !list)
			return;
		
		if (list.dataProvider != _dataProvider)
			list.dataProvider = _dataProvider;
		
		var selectedIndex:int = -1;
		if (_look)
		{
			var n:int = _dataProvider ? _dataProvider.length : 0;
			for (var i:int = 0; i < n; i++)
			{
				if (LookLink(_dataProvider[i]).name == _look.name)
				{
					selectedIndex = i;
					break;
				}
			}
		}
		list.selectedIndex = selectedIndex;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Event handlers
	//
	//--------------------------------------------------------------------------
	
	private function list_changeHandler(event:IndexChangeEvent):void
	{
		controller.lookManager.lookLink = list.selectedItem as LookLink;
	}

	private function lookManager_lookChangeHandler(event:Event):void
	{
		look = controller.lookManager.look;
	}
	
}
}