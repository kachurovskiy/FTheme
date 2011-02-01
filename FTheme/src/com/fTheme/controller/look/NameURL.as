package com.fTheme.controller.look
{
import flash.events.EventDispatcher;

public class NameURL extends EventDispatcher
{
	
	public function NameURL(text:String = null)
	{
		super();
		
		if (text)
			parse(text);
	}
	
	[Bindable]
	public var name:String;
	
	[Bindable]
	public var url:String;
	
	public function parse(text:String):void
	{
		var parts:Array = text.split(/\s/);
		var possibleURL:String = parts[parts.length - 1];
		if (possibleURL && possibleURL.indexOf(".") > 0) // at least domain.com
		{
			url = possibleURL;
			parts.pop();
		}
		
		name = parts.join(" ");
	}
	
	public function toTLFXML():XML
	{
		if (url)
			return <a xmlns="http://ns.adobe.com/textLayout/2008" href={url}>{name ? name : url}</a>;
		return <span xmlns="http://ns.adobe.com/textLayout/2008">{name}</span>;
	}
	
}
}