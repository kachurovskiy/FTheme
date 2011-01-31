package com.fTheme.controller.asset
{
import flash.events.Event;

/**
 * This event is dispatched by AssetManager.
 */
public class AssetManagerEvent extends Event
{
	
	public static const ASSET_CHANGE:String = "assetChange";
	
	public function AssetManagerEvent(type:String, assetId:String = null)
	{
		super(type, bubbles, cancelable);
		
		this.assetId = assetId;
	}
	
	public var assetId:String;
	
}
}