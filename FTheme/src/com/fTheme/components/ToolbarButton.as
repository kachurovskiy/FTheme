package com.fTheme.components
{
import spark.components.Button;

public class ToolbarButton extends Button
{
	
	public function ToolbarButton()
	{
		super();
		
		setStyle("skinClass", ToolbarButtonSkin);
	}
	
	[Bindable]
	/**
	 * <code>Bitmap</code>, <code>BitmapData</code> or <code>DisplayObject</code>.
	 */
	public var icon:*;
	
}
}