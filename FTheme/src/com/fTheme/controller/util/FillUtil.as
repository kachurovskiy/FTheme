package com.fTheme.controller.util
{
import com.fTheme.controller.FThemeController;

import mx.graphics.BitmapFillMode;
import mx.graphics.GradientBase;
import mx.graphics.GradientEntry;
import mx.graphics.IFill;
import mx.graphics.LinearGradient;
import mx.graphics.RadialGradient;
import mx.utils.StringUtil;

/**
 * Provides various operations on <code>IFill</code> fills.
 */
public class FillUtil
{
	
	public static function stringToFill(string:String):IFill
	{
		string = StringUtil.trim(string);
		if (!string)
			return null;
		
		var parts:Array = string.split(/\s/); // split by whitespace
		var part0:String = parts[0];
		if (part0 == "radial")
			return arrayToRadialGradient(parts);
		else if (part0 == "bitmap")
			return arrayToBitmapFill(parts);
		else
			return arrayToLinearGradient(parts);
	}
	
	private static function arrayToLinearGradient(parts:Array):LinearGradient
	{
		var linearGradient:LinearGradient = new LinearGradient();
		arrayToGradientBase(parts, linearGradient);
		
		var n:int = parts.length;
		for (var i:int = 0; i < n; i++)
		{
			var part:String = parts[i];
			if (part == "scaleX")
				linearGradient.scaleX = Number(parts[++i]);
		}
		
		return linearGradient;
	}
	
	private static function arrayToRadialGradient(parts:Array):RadialGradient
	{
		parts.shift(); // remove "radial" word
		
		var radialGradient:RadialGradient = new RadialGradient();
		arrayToGradientBase(parts, radialGradient);
		
		var n:int = parts.length;
		for (var i:int = 0; i < n; i++)
		{
			var part:String = parts[i];
			if (part == "scaleX")
				radialGradient.scaleX = Number(parts[++i]);
			else if (part == "scaleY")
				radialGradient.scaleY = Number(parts[++i]);
			else if (part == "focalPointRatio")
				radialGradient.focalPointRatio = Number(parts[++i]);
		}
		
		return radialGradient;
	}

	private static function arrayToGradientBase(parts:Array, gradientBase:GradientBase):void
	{
		var n:int = parts.length;
		var entries:Array = [];
		var entry:GradientEntry;
		gradientBase.rotation = 90;
		for (var i:int = 0; i < n; i++)
		{
			var part:String = parts[i];
			if (part == "rotation")
			{
				gradientBase.rotation = Number(parts[++i]);
			}
			else if (part == "spreadMethod")
			{
				gradientBase.spreadMethod = parts[++i];
			}
			else if (part.indexOf("0x") == 0 || part.charAt(0) == "#")
			{
				if (entry)
					entries.push(entry);
				entry = new GradientEntry(ColorUtil.stringToUint(part));
			}
			else if (entry && part == "ratio")
			{
				entry.ratio = Number(parts[++i]);
			}
			else if (entry && part == "alpha")
			{
				entry.alpha = Number(parts[++i]);
			}
			else if (entry)
			{
				entries.push(entry);
				entry = null;
			}
		}
		if (entry)
			entries.push(entry);
		gradientBase.entries = entries;
	}
	
	/**
	 * Parses splitted string into bitmap fill.
	 * 
	 * @return Custom fill <code>BitmapFill2</code> since <code>BitmapFill</code>
	 * does not support scale-9-grid.
	 */
	private static function arrayToBitmapFill(parts:Array):BitmapFill2
	{
		parts.shift(); // remove "bitmap" word
		
		var assetId:String = parts.shift();
		var bitmapFill:BitmapFill2 = new BitmapFill2();
		var classValue:Class = FThemeController.instance.assetManager.getAsset(assetId);
		if (!classValue)
			return null;
		bitmapFill.source = new classValue();
		
		var n:int = parts.length;
		for (var i:int = 0; i < n; i++)
		{
			var part:String = parts[i];
			if (part == "fillMode")
				bitmapFill.fillMode = parts[++i];
			else if (part == "horizontalAlign")
				bitmapFill.horizontalAlign = parts[++i];
			else if (part == "verticalAlign")
				bitmapFill.verticalAlign = parts[++i];
			else if (part == "maintainAspectRatio")
				bitmapFill.maintainAspectRatio = parts[++i] == "true";
			else if (part == "smooth")
				bitmapFill.smooth = parts[++i] == "true";
			else if (part == "rotation")
				bitmapFill.rotation = Number(parts[++i]);
			else if (part == "x")
				bitmapFill.constantX = Number(parts[++i]);
			else if (part == "y")
				bitmapFill.constantY = Number(parts[++i]);
		}
		
		return bitmapFill;
	}
	
}
}