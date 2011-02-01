package com.fTheme.view.selector
{
import com.fTheme.controller.FThemeController;
import com.fTheme.controller.look.Author;
import com.fTheme.controller.look.License;
import com.fTheme.controller.look.Look;
import com.fTheme.controller.look.LookLink;
import com.fTheme.controller.look.LookManager;

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
 * UI component that allows user to select and apply look and feel.
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
		
		_managerDataProvider = lookManager.lookLinks;
		lookManager.addEventListener("lookLinksChange", lookManager_lookLinksChange, false, 0, true);
		
		_look = lookManager.look;
		lookManager.addEventListener("lookChange", lookManager_lookChangeHandler, false, 0, true);
	}
	
	//--------------------------------------------------------------------------
	//
	//  Variables
	//
	//--------------------------------------------------------------------------
	
	[Bindable("__NoChangeEvent__")]
	private var lookManager:LookManager = FThemeController.instance.lookManager;
	
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

	private var _explicitDataProvider:* = undefined;
	
	private var _managerDataProvider:IList;

	[Bindable("dataProviderChange")]
	/**
	 * Usually list of <code>LookLink</code> instances is provided by 
	 * <code>LookManager</code> but it can be set explicitly too.
	 */
	public function get dataProvider():IList 
	{
		return _explicitDataProvider;
	}

	public function set dataProvider(value:IList):void
	{
		if (_explicitDataProvider == value)
			return;
		
		_explicitDataProvider = value;
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
		var provider:IList;
		if (_explicitDataProvider !== undefined)
			provider = _explicitDataProvider;
		else if (_managerDataProvider)
			provider = _managerDataProvider;
			
		if (!provider || !list)
			return;
		
		if (list.dataProvider != provider)
			list.dataProvider = provider;
		
		var selectedIndex:int = -1;
		if (_look)
		{
			var n:int = provider ? provider.length : 0;
			for (var i:int = 0; i < n; i++)
			{
				if (LookLink(provider[i]).name == _look.name)
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
		lookManager.lookLink = list.selectedItem as LookLink;
	}

	private function lookManager_lookChangeHandler(event:Event):void
	{
		look = lookManager.look;
	}

	private function lookManager_lookLinksChange(event:Event):void
	{
		_managerDataProvider = lookManager.lookLinks;
		updateList();
	}
	
}
}