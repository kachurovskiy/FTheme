package com.fTheme.components
{
import com.fTheme.FThemeController;
import com.fTheme.look.Author;
import com.fTheme.look.License;
import com.fTheme.look.Look;
import com.fTheme.look.LookLink;
import com.fTheme.look.LookManager;

import flash.events.Event;

import flashx.textLayout.elements.TextFlow;
import flashx.textLayout.formats.WhiteSpaceCollapse;

import spark.components.RichEditableText;
import spark.components.supportClasses.SkinnableComponent;
import spark.utils.TextFlowUtil;

public class LookInfo extends SkinnableComponent
{
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------

	public function LookInfo()
	{
		super();
		
		setStyle("skinClass", LookInfoSkin);
		
		look = lookManager.look;
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
	public var richEditableText:RichEditableText;
	
	private var look:Look;
	
	//--------------------------------------------------------------------------
	//
	//  Overriden methods
	//
	//--------------------------------------------------------------------------

	override protected function partAdded(partName:String, instance:Object):void
	{
		super.partAdded(partName, instance);
		
		if (instance == richEditableText)
			update();
	}
	
	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------
	
	private function update():void
	{
		if (!richEditableText || !look)
			return;
		
		richEditableText.textFlow = getTextFlow();
	}
	
	private function getTextFlow():TextFlow
	{
		var textFlow:TextFlow;
		XML.ignoreWhitespace = false;
		var xml:XML = <TextFlow xmlns="http://ns.adobe.com/textLayout/2008"/>;
		var authors:Vector.<Author> = look.authors;
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
		var licenses:Vector.<License> = look.licenses;
		n = licenses ? licenses.length : 0;
		if (n > 0)
		{
			paragraph = <p xmlns="http://ns.adobe.com/textLayout/2008">License: </p>;
			for (i = 0; i < n; i++)
			{
				if (i > 0)
					paragraph.appendChild(delimeter.copy());
				paragraph.appendChild(licenses[i].toTLFXML());
			}
			xml.appendChild(paragraph);
		}
		if (xml.*.length() == 0) // no info about authors and licenses
		{
			var noInfoText:String = "No info about " + look.name;
			xml.appendChild(<p xmlns="http://ns.adobe.com/textLayout/2008">{noInfoText}</p>);
		}
		textFlow = TextFlowUtil.importFromXML(xml, WhiteSpaceCollapse.PRESERVE);
		XML.ignoreWhitespace = true;
		return textFlow;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Event handlers
	//
	//--------------------------------------------------------------------------
	
	private function lookManager_lookChangeHandler(event:Event):void
	{
		look = lookManager.look;
		update();
	}

}
}