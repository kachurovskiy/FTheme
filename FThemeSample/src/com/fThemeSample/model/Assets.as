package com.fThemeSample.model
{
import flash.events.EventDispatcher;

public class Assets extends EventDispatcher
{
	
	[Bindable("__NoChangeEvent__")]
	[Embed("icon1.png")]
	public var icon1:Class;
	
	[Bindable("__NoChangeEvent__")]
	[Embed("icon2.png")]
	public var icon2:Class;
	
}
}