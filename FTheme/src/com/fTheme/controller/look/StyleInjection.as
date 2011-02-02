package com.fTheme.controller.look
{
public class StyleInjection
{
	public function StyleInjection(selector:String, styleName:String)
	{
		super();
		
		this.selector = selector;
		this.styleName = styleName;
	}
	
	public var selector:String;
	
	public var styleName:String;
	
}
}