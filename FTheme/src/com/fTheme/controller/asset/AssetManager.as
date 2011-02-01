package com.fTheme.controller.asset
{
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.events.EventDispatcher;
import flash.geom.Point;

/**
 * Is dispatched when some asset changes.
 */
[Event(name="assetChange", type="com.fTheme.controller.asset.AssetManagerEvent")]
/**
 * Stores bitmap assets and provides methods to retrieve and modify assets.
 * 
 * @see http://kachurovskiy.com/2010/storing-icons-in-external-zip-and-seamless-work-with-composite-icons/
 */
public class AssetManager extends EventDispatcher
{
	
	//--------------------------------------------------------------------------
	//
	//  Variables
	//
	//--------------------------------------------------------------------------

	/**
	 * Maps asset id to the value.
	 */
	private var assets:Object = {};
	
	/**
	 * Maps icon id to <code>Vector</code> of <code>String</code> that are 
	 * ids of layered icons. Is used to update layered icons when simple icon changes. 
	 */
	private var iconDependencies:Object = {};
	
	/**
	 * Maps layered icon id to <code>BitmapData</code>.
	 */
	private var layeredIconBitmapDatas:Object = {};
	
	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------

	/**
	 * Returns asset value by it's id.
	 */
	public function getAsset(id:String):*
	{
		if (assets[id])
			return assets[id];
		
		if (id.indexOf("+") == -1) // is not a layered icon
			return undefined;
		
		updateLayeredIcon(id);
		return assets[id];
	}
	
	private function updateLayeredIcon(id:String):void
	{
		var bitmapData:BitmapData = getLayeredIconBitmapData(id, layeredIconBitmapDatas[id]);
		layeredIconBitmapDatas[id] = bitmapData;
		if (!bitmapData)
		{
			setAsset(id, undefined);
		}
		else if (!assets[id])
		{
			var classValue:Class = RuntimeBitmapAsset.getClass(bitmapData);
			setAsset(id, classValue);
		}
		// else if class is already registered we do not need to set new class
		// since we have already updated the BitmapData and all instances are 
		// updated automatically
	}
	
	private function getLayeredIconBitmapData(id:String, 
		existingBitmapData:BitmapData = null):BitmapData
	{
		if (existingBitmapData) // clear it
			existingBitmapData.fillRect(existingBitmapData.rect, 0x00000000);
		
		var layers:Array = id.split("+");
		var n:int = layers.length;
		for (var i:int = 0; i < n; i++)
		{
			var layer:String = layers[i];
			
			// update assetDependencies
			var vector:Vector.<String> = iconDependencies[layer];
			if (!vector)
			{
				vector = new Vector.<String>();
				iconDependencies[layer] = vector;
			}
			if (vector.indexOf(id) == -1)
				vector.push(id);
			
			// update existingBitmapData
			var layerClass:Class = assets[layer];
			var layerBitmapData:BitmapData = null;
			if (layerClass)
			{
				var layerInstance:* = new layerClass();
				if (layerInstance is Bitmap)
				{
					layerBitmapData = Bitmap(layerInstance).bitmapData;
				}
				else if (layerInstance is DisplayObject)
				{
					var displayObject:DisplayObject = DisplayObject(layerInstance);
					layerBitmapData = new BitmapData(displayObject.width, 
						displayObject.height, true, 0x00000000);
					layerBitmapData.draw(displayObject);
				}	
			}
			if (!layerBitmapData)
			{
				if (i == 0) // first layer defines the size of resulting BitmapData
				{
					existingBitmapData = null;
					break;
				}
				else
				{
					continue;
				}
			}
			
			if (existingBitmapData)
				existingBitmapData.copyPixels(layerBitmapData, layerBitmapData.rect,
					new Point(0, 0), null, null, true);
			else
				existingBitmapData = layerBitmapData.clone();
		}
		return existingBitmapData;
	}
	
	/**
	 * Sets asset (e.g. icon) with name <code>id</code> to a given value (e.g. Class).
	 */
	public function setAsset(id:String, value:*):void
	{
		if (assets[id] === value)
			return;
		
		if (value == undefined)
			delete assets[id];
		else
			assets[id] = value;

		notifyAboutAssetChange(id);
	}
	
	/**
	 * Clear previously setted asset.
	 */
	public function clearAsset(id:String):void
	{
		setAsset(id, undefined);
	}
	
	private function notifyAboutAssetChange(id:String):void
	{
		var event:AssetManagerEvent = new AssetManagerEvent(AssetManagerEvent.ASSET_CHANGE, id);
		dispatchEvent(event);
		
		// if it's not a layered icon - check if this asset was used as a part
		// of some layered icon and if yes, then update all such layered icons
		var layeredIconIds:Vector.<String> = iconDependencies[id];
		if (layeredIconIds)
		{
			var n:int = layeredIconIds.length;
			for (var i:int = 0; i < n; i++)
			{
				updateLayeredIcon(layeredIconIds[i]);
			}
		}
	}
	
	public function destroy():void
	{
		assets = null;
		iconDependencies = null;
		layeredIconBitmapDatas = null;
	}
	
}
}