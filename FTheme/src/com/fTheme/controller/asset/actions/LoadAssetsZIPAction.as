package com.fTheme.controller.asset.actions
{
import com.fTheme.controller.asset.AssetManager;
import com.fTheme.controller.asset.RuntimeBitmapAsset;

import deng.fzip.FZip;
import deng.fzip.FZipErrorEvent;
import deng.fzip.FZipFile;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Loader;
import flash.display.LoaderInfo;
import flash.events.ErrorEvent;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.IOErrorEvent;
import flash.events.SecurityErrorEvent;
import flash.net.URLRequest;

import mx.controls.Alert;
import mx.core.FlexGlobals;

/**
 * Dispathed when load is successfuly completed.
 */
[Event(name="complete", type="flash.events.Event")]
/**
 * Dispatched when load fails.
 */
[Event(name="error", type="flash.events.ErrorEvent")]

/**
 * Loads ZIP with images and adds them to <code>AssetManager</code>.
 */
public class LoadAssetsZIPAction extends EventDispatcher
{
	
	private var fZip:FZip;
	
	private var fileName:String;
	
	private var assetManager:AssetManager;
	
	private var assetFileNames:Vector.<String> = new Vector.<String>();
	private var loaders:Vector.<Loader> = new Vector.<Loader>();
	
	private var loadersComplete:int;
	
	public function start(fileName:String, assetManager:AssetManager):void
	{
		this.fileName = fileName;
		this.assetManager = assetManager;
		
		FlexGlobals.topLevelApplication.cursorManager.setBusyCursor();
		
		fZip = new FZip();
		fZip.addEventListener(FZipErrorEvent.PARSE_ERROR, errorHandler);
		fZip.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
		fZip.addEventListener(SecurityErrorEvent.SECURITY_ERROR, errorHandler);
		fZip.addEventListener(Event.COMPLETE, completeHandler);
		fZip.load(new URLRequest(fileName));
	}
	
	private function finish(errorText:String = null):void
	{
		if (errorText)
			dispatchEvent(new ErrorEvent(ErrorEvent.ERROR, false, false, errorText));
		else
			dispatchEvent(new Event(Event.COMPLETE));
	}
	
	private function errorHandler(event:FZipErrorEvent):void
	{
		FlexGlobals.topLevelApplication.cursorManager.removeBusyCursor();
		
		var errorText:String;
		if (event is FZipErrorEvent)
			errorText = FZipErrorEvent(event).text;
		else if (event is ErrorEvent)
			errorText = ErrorEvent(event).text;
		else
			errorText = event.toString();
		finish("Error while loading \"" + fileName + "\": " + errorText);
	}
	
	private function completeHandler(event:Event):void
	{
		FlexGlobals.topLevelApplication.cursorManager.removeBusyCursor();
		
		var n:int = fZip.getFileCount();
		loadersComplete = 0;
		for (var i:int = 0; i < n; i++)
		{
			var file:FZipFile = fZip.getFileAt(i);
			var loader:Loader = new Loader();
			loaders.push(loader);
			loader.contentLoaderInfo.addEventListener(Event.INIT, loader_someHandler);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, loader_someHandler);
			assetFileNames.push(file.filename);
			loader.loadBytes(file.content);
		}
	}
	
	private function loader_someHandler(event:Event):void
	{
		var loaderInfo:LoaderInfo = LoaderInfo(event.target);
		loaderInfo.removeEventListener(Event.INIT, loader_someHandler);
		loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, loader_someHandler);
		
		loadersComplete++;
		var n:int = loaders.length;
		if (loadersComplete == n)
		{
			for (var i:int = 0; i < n; i++)
			{
				var loader:Loader = loaders[i];
				var assetFileName:String = assetFileNames[i];
				var assetId:String = assetFileName.substring(0, assetFileName.lastIndexOf("."));
				var assetClass:Class = null;
				
				try
				{
					assetClass = loader.contentLoaderInfo.applicationDomain.getDefinition(assetId) as Class;
				}
				catch (error:*) {}
				
				if (!assetClass)
				{
					try
					{
						var bitmap:Bitmap = loader.content as Bitmap;
						var bitmapData:BitmapData = bitmap ? bitmap.bitmapData : null;
						if (bitmapData)
							assetClass = RuntimeBitmapAsset.getClass(bitmapData);
					}
					catch (error:*) {}
				}
				
				if (assetClass)
					assetManager.setAsset(assetId, assetClass);
				else
					trace("Failed to load asset \"" + assetId + "\"");
			}
			
			finish();
		}
	}
	
}
}