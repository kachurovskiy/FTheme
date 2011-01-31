package com.fTheme.controller.util
{
import flash.display.Graphics;
import flash.geom.Point;
import flash.geom.Rectangle;

import mx.graphics.BitmapFill;

/**
 * Adds support for <code>scale9Grid</code>.
 */
public class BitmapFill2 extends BitmapFill
{
	
	//--------------------------------------------------------------------------
	//
	//  Overriden methods
	//
	//--------------------------------------------------------------------------

	override public function begin(target:Graphics, targetBounds:Rectangle, targetOrigin:Point):void
	{
		// TODO: add scale9Grid support (copy from Spark BitmapImage)
		
		super.begin(target, targetBounds, targetOrigin);
	}
	
}
}