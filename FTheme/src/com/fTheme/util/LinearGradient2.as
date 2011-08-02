package com.fTheme.util
{
import mx.graphics.LinearGradient;

public class LinearGradient2 extends LinearGradient
{
	
	override public function addEventListener(type:String, listener:Function, 
											  useCapture:Boolean=false, priority:int=0, 
											  useWeakReference:Boolean=false):void
	{
		// fills and strokes are not edited in FTheme, they are recreated each time
		// so we don't need this listeners added by Rects and Lines
		// more than that if we allow them it will cause a giant memory leak
		// when all skins thay in memory forever because this fill links to them
	}
	
	override public function removeEventListener(type:String, listener:Function, 
												 useCapture:Boolean=false):void
	{
	}
	
}
}