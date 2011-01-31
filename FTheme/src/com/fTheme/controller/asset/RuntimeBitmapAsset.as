package com.fTheme.controller.asset
{
import flash.display.BitmapData;
import flash.utils.getQualifiedClassName;

import mx.core.BitmapAsset;

/**
 * Allows to work with arbitary runtime <code>BitmapData</code> as a 
 * <code>Class</code> that is neccessary since e.g. MX Button allows only
 * <code>Class</code> as the value for it's <code>icon</code>.
 * 
 * @see http://kachurovskiy.com/2010/runtime-icons-for-flex-components/
 */
public class RuntimeBitmapAsset extends BitmapAsset
{
	
	/**
	 * @private
	 * Maps class index to corresponding <code>BitmapData</code>.
	 */
	private static var bitmapDatas:Object = {};
	
	private static var classes:Vector.<Class>;
	
	private static var classesIndex:int = 0;
	
	/**
	 * Returns a <code>Class</code> that is a child of <code>BitmapAsset</code>
	 * and instantiates with given <code>bitmapData</code> inside.
	 */
	public static function getClass(bitmapData:BitmapData):Class
	{
		if (!classes)
		{
			classes = Vector.<Class>(
				[
					B0, B1, B2, B3, B4, B5, B6, B7, B8, B9,
					B10, B11, B12, B13, B14, B15, B16, B17, B18, B19,
					B20, B21, B22, B23, B24, B25, B26, B27, B28, B29,
					B30, B31, B32, B33, B34, B35, B36, B37, B38, B39,
					B40, B41, B42, B43, B44, B45, B46, B47, B48, B49,
					B50, B51, B52, B53, B54, B55, B56, B57, B58, B59,
					B60, B61, B62, B63, B64, B65, B66, B67, B68, B69,
					B70, B71, B72, B73, B74, B75, B76, B77, B78, B79,
					B80, B81, B82, B83, B84, B85, B86, B87, B88, B89,
					B90, B91, B92, B93, B94, B95, B96, B97, B98, B99 
				]);
		}
		
		if (classesIndex == classes.length)
			throw new Error("No more template classes available");
		
		var classValue:Class = classes[classesIndex];
		bitmapDatas[classesIndex] = bitmapData;
		classesIndex++;
		return classValue;
	}
	
	/**
	 * Clears all stored BitmapData-s. All previously issued Classes can not be 
	 * instantiated anymore.
	 */
	public static function clear():void
	{
		bitmapDatas = {};
		classesIndex = 0;
	}
	
	public function RuntimeBitmapAsset()
	{
		var className:String = getQualifiedClassName(this);
		var shortClassName:String = className.split("::").pop(); // like B78
		var index:String = shortClassName.substr(1); // remove B
		var bitmapData:BitmapData = bitmapDatas[index];
		
		super(bitmapData);
		
		if (!bitmapData)
			throw new Error("BitmapData for class B" + index + " is not defined");
	}
}
}
import com.fTheme.controller.asset.RuntimeBitmapAsset;

class B0 extends RuntimeBitmapAsset {}
class B1 extends RuntimeBitmapAsset {}
class B2 extends RuntimeBitmapAsset {}
class B3 extends RuntimeBitmapAsset {}
class B4 extends RuntimeBitmapAsset {}
class B5 extends RuntimeBitmapAsset {}
class B6 extends RuntimeBitmapAsset {}
class B7 extends RuntimeBitmapAsset {}
class B8 extends RuntimeBitmapAsset {}
class B9 extends RuntimeBitmapAsset {}

class B10 extends RuntimeBitmapAsset {}
class B11 extends RuntimeBitmapAsset {}
class B12 extends RuntimeBitmapAsset {}
class B13 extends RuntimeBitmapAsset {}
class B14 extends RuntimeBitmapAsset {}
class B15 extends RuntimeBitmapAsset {}
class B16 extends RuntimeBitmapAsset {}
class B17 extends RuntimeBitmapAsset {}
class B18 extends RuntimeBitmapAsset {}
class B19 extends RuntimeBitmapAsset {}

class B20 extends RuntimeBitmapAsset {}
class B21 extends RuntimeBitmapAsset {}
class B22 extends RuntimeBitmapAsset {}
class B23 extends RuntimeBitmapAsset {}
class B24 extends RuntimeBitmapAsset {}
class B25 extends RuntimeBitmapAsset {}
class B26 extends RuntimeBitmapAsset {}
class B27 extends RuntimeBitmapAsset {}
class B28 extends RuntimeBitmapAsset {}
class B29 extends RuntimeBitmapAsset {}

class B30 extends RuntimeBitmapAsset {}
class B31 extends RuntimeBitmapAsset {}
class B32 extends RuntimeBitmapAsset {}
class B33 extends RuntimeBitmapAsset {}
class B34 extends RuntimeBitmapAsset {}
class B35 extends RuntimeBitmapAsset {}
class B36 extends RuntimeBitmapAsset {}
class B37 extends RuntimeBitmapAsset {}
class B38 extends RuntimeBitmapAsset {}
class B39 extends RuntimeBitmapAsset {}

class B40 extends RuntimeBitmapAsset {}
class B41 extends RuntimeBitmapAsset {}
class B42 extends RuntimeBitmapAsset {}
class B43 extends RuntimeBitmapAsset {}
class B44 extends RuntimeBitmapAsset {}
class B45 extends RuntimeBitmapAsset {}
class B46 extends RuntimeBitmapAsset {}
class B47 extends RuntimeBitmapAsset {}
class B48 extends RuntimeBitmapAsset {}
class B49 extends RuntimeBitmapAsset {}

class B50 extends RuntimeBitmapAsset {}
class B51 extends RuntimeBitmapAsset {}
class B52 extends RuntimeBitmapAsset {}
class B53 extends RuntimeBitmapAsset {}
class B54 extends RuntimeBitmapAsset {}
class B55 extends RuntimeBitmapAsset {}
class B56 extends RuntimeBitmapAsset {}
class B57 extends RuntimeBitmapAsset {}
class B58 extends RuntimeBitmapAsset {}
class B59 extends RuntimeBitmapAsset {}

class B60 extends RuntimeBitmapAsset {}
class B61 extends RuntimeBitmapAsset {}
class B62 extends RuntimeBitmapAsset {}
class B63 extends RuntimeBitmapAsset {}
class B64 extends RuntimeBitmapAsset {}
class B65 extends RuntimeBitmapAsset {}
class B66 extends RuntimeBitmapAsset {}
class B67 extends RuntimeBitmapAsset {}
class B68 extends RuntimeBitmapAsset {}
class B69 extends RuntimeBitmapAsset {}

class B70 extends RuntimeBitmapAsset {}
class B71 extends RuntimeBitmapAsset {}
class B72 extends RuntimeBitmapAsset {}
class B73 extends RuntimeBitmapAsset {}
class B74 extends RuntimeBitmapAsset {}
class B75 extends RuntimeBitmapAsset {}
class B76 extends RuntimeBitmapAsset {}
class B77 extends RuntimeBitmapAsset {}
class B78 extends RuntimeBitmapAsset {}
class B79 extends RuntimeBitmapAsset {}

class B80 extends RuntimeBitmapAsset {}
class B81 extends RuntimeBitmapAsset {}
class B82 extends RuntimeBitmapAsset {}
class B83 extends RuntimeBitmapAsset {}
class B84 extends RuntimeBitmapAsset {}
class B85 extends RuntimeBitmapAsset {}
class B86 extends RuntimeBitmapAsset {}
class B87 extends RuntimeBitmapAsset {}
class B88 extends RuntimeBitmapAsset {}
class B89 extends RuntimeBitmapAsset {}

class B90 extends RuntimeBitmapAsset {}
class B91 extends RuntimeBitmapAsset {}
class B92 extends RuntimeBitmapAsset {}
class B93 extends RuntimeBitmapAsset {}
class B94 extends RuntimeBitmapAsset {}
class B95 extends RuntimeBitmapAsset {}
class B96 extends RuntimeBitmapAsset {}
class B97 extends RuntimeBitmapAsset {}
class B98 extends RuntimeBitmapAsset {}
class B99 extends RuntimeBitmapAsset {}