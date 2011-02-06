package com.fTheme.util
{
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Graphics;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;

import mx.geom.CompoundTransform;
import mx.graphics.BitmapFill;
import mx.graphics.BitmapFillMode;

import spark.layouts.HorizontalAlign;
import spark.layouts.VerticalAlign;

/**
 * Adds support for <code>scale9Grid</code>.
 */
public class BitmapFill2 extends BitmapFill
{
	
	//--------------------------------------------------------------------------
	//
	//  Variables
	//
	//--------------------------------------------------------------------------

	public var horizontalAlign:String = HorizontalAlign.LEFT;
	
	public var verticalAlign:String = VerticalAlign.TOP;
	
	/**
	 * Used when <code>fillMode</code> is "scale".
	 */
	public var maintainAspectRatio:Boolean = false;
	
	public var constantX:Number = 0;
	
	public var constantY:Number = 0;
	
	//--------------------------------------------------------------------------
	//
	//  Overriden methods
	//
	//--------------------------------------------------------------------------

	override public function begin(target:Graphics, targetBounds:Rectangle, targetOrigin:Point):void
	{
		if (!(source as Bitmap))
		{
			target.clear();
			return;
		}
		
		var bitmapData:BitmapData = Bitmap(source).bitmapData;
		var newMatrix:Matrix = new Matrix();
		
		// some fills should be done not from (0, 0) of the Graphics but from
		// some other point e.g. MX Panel control bar is drawn from (panelHeight-19, 1)
		newMatrix.translate(targetOrigin.x, targetOrigin.y);
		
		if (fillMode == BitmapFillMode.SCALE)
		{
			var sx:Number = targetBounds.width / bitmapData.width;
			var sy:Number = targetBounds.height / bitmapData.height;
			if (maintainAspectRatio)
				sx = sy = Math.max(sx, sy);
			newMatrix.scale(sx, sy);
			if (maintainAspectRatio)
				newMatrix.translate((targetBounds.width - bitmapData.width * sx) / 2,
					(targetBounds.height - bitmapData.height * sy) / 2);
			
			target.beginBitmapFill(bitmapData, newMatrix, false, smooth);
		}
		else
		{
			var dx:Number = constantX;
			var dy:Number = constantY;
			
			// adjust dx according to horizontalAlign
			if (horizontalAlign == HorizontalAlign.RIGHT)
				dx = targetBounds.width - bitmapData.width;
			else if (horizontalAlign == HorizontalAlign.CENTER)
				dx = (targetBounds.width - bitmapData.width) / 2;
			
			// adjust dy according to verticalAlign
			if (verticalAlign == VerticalAlign.BOTTOM)
				dy = targetBounds.height - bitmapData.height;
			else if (verticalAlign == VerticalAlign.MIDDLE)
				dy = (targetBounds.height - bitmapData.height) / 2;
			
			newMatrix.translate(dx, dy);
			
			if (fillMode == BitmapFillMode.REPEAT)
			{
				target.beginBitmapFill(bitmapData, newMatrix, true, smooth);
			}
			else // if (fillMode == BitmapFillMode.CLIP)
			{
				target.beginBitmapFill(bitmapData, newMatrix, false, smooth);
			}
		}
	}
	
}
}