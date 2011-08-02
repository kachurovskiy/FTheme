package com.fTheme.look.actions
{
import com.fTheme.asset.actions.LoadAssetsZIPAction;
import com.fTheme.look.Author;
import com.fTheme.look.License;
import com.fTheme.look.Look;
import com.fTheme.look.LookLink;
import com.fTheme.look.LookLinkStatus;

import flash.events.ErrorEvent;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.events.SecurityErrorEvent;
import flash.net.URLLoader;
import flash.net.URLRequest;

import mx.utils.StringUtil;

/**
 * Dispatched when load process is successfuly completed.
 */
[Event(name="complete", type="flash.events.Event")]
/**
 * Dispatched when load has failed with error.
 */
[Event(name="error", type="flash.events.ErrorEvent")]
/**
 * Dispatched when load progress changes.
 */
[Event(name="progress", type="flash.events.ProgressEvent")]

/**
 * Loads look from text file. If bitmaps are used, ZIP file with the same
 * is also loaded and parsed into <code>Look</code> instance.
 */
public class LoadLookAction extends EventDispatcher
{
	
	//--------------------------------------------------------------------------
	//
	//  Variables
	//
	//--------------------------------------------------------------------------

	private var lookLink:LookLink;
	
	private var urlLoader:URLLoader;
	
	private var look:Look;
	
	private var loadAssetsZIPAction:LoadAssetsZIPAction;
	
	private var zipFileURL:String;
	
	private var progress:Number = -1;
	
	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------

	/**
	 * Starts action.
	 * 
	 * @param lookLink Look link instance.
	 */
	public function start(lookLink:LookLink):void
	{
		if (lookLink.status == LookLinkStatus.LOADED)
		{
			dispatchEvent(new Event(Event.COMPLETE));
			return;
		}
		
		this.lookLink = lookLink;
		
		lookLink.status = LookLinkStatus.LOADING;
		
		urlLoader = new URLLoader();
		urlLoader.addEventListener(ProgressEvent.PROGRESS, urlLoader_progressHandler);
		urlLoader.addEventListener(Event.COMPLETE, urlLoader_completeHandler);
		urlLoader.addEventListener(IOErrorEvent.IO_ERROR, urlLoader_errorHandler);
		urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, urlLoader_errorHandler);
		urlLoader.load(new URLRequest(lookLink.txtFileURL));
	}
	
	private function indicateProgress(progress:Number):void
	{
		if (this.progress >= progress)
			return;
		
		this.progress = progress;
		var newEvent:ProgressEvent = new ProgressEvent(ProgressEvent.PROGRESS, 
			false, false, progress, 1);
		dispatchEvent(newEvent);
		lookLink.dispatchEvent(newEvent);
	}
	
	private function finish(errorText:String = null):void
	{
		lookLink.look = errorText ? null : look;
		lookLink.status = errorText ? LookLinkStatus.ERROR : LookLinkStatus.LOADED;
		lookLink.errorText = errorText;
		
		if (errorText)
			dispatchEvent(new ErrorEvent(ErrorEvent.ERROR, false, false, errorText));
		else
			dispatchEvent(new Event(Event.COMPLETE));
		
		if (loadAssetsZIPAction)
		{
			loadAssetsZIPAction.removeEventListener(ProgressEvent.PROGRESS, loadAssetsZIPAction_progressHandler);
			loadAssetsZIPAction.removeEventListener(Event.COMPLETE, loadAssetsZIPAction_completeHandler);
			loadAssetsZIPAction.removeEventListener(ErrorEvent.ERROR, loadAssetsZIPAction_errorHandler);
			loadAssetsZIPAction = null;
		}
		
		urlLoader.removeEventListener(ProgressEvent.PROGRESS, urlLoader_progressHandler);
		urlLoader.removeEventListener(Event.COMPLETE, urlLoader_completeHandler);
		urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, urlLoader_errorHandler);
		urlLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, urlLoader_errorHandler);
		urlLoader = null;
		
		lookLink = null;
		look = null;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Event handlers
	//
	//--------------------------------------------------------------------------

	private function urlLoader_progressHandler(event:ProgressEvent):void
	{
		indicateProgress(event.bytesLoaded / event.bytesTotal * 2);
	}
	
	private function urlLoader_completeHandler(event:Event):void
	{
		var text:String = urlLoader.data;
		var lines:Array = text.split(/\n|\r/g);
		var numLines:int = lines.length;
		var i:int;
		var nameValueMap:Object = {};
		var authors:Vector.<Author> = new Vector.<Author>();
		var licenses:Vector.<License> = new Vector.<License>();
		for (i = 0; i < numLines; i++)
		{
			// line example: "panelStroke: 0xFFFFFF alpha 0.8"
			var line:String = StringUtil.trim(lines[i]);
			if (line.charAt(0) == "@") // @author, @license, ...
			{
				var parts:Array = line.substr(1).split(/\s/);
				var type:String = parts.shift();
				if (type == "author")
					authors.push(new Author(parts.join(" ")));
				else if (type == "license")
					licenses.push(new License(parts.join(" ")));
				continue;
			}
			var dotsIndex:int = line.indexOf(":");
			if (dotsIndex == -1)
				continue;
			
			var name:String = StringUtil.trim(line.substring(0, dotsIndex));
			var value:String = StringUtil.trim(line.substr(dotsIndex + 1));
			if (!name || !value)
				continue;
			
			nameValueMap[name] = value;
		}
		
		look = new Look(lookLink.name);
		look.authors = authors;
		look.licenses = licenses;
		look.nameValueMap = nameValueMap;
		
		// if look does not need bitmaps, we're done
		if (!look.usesBitmaps)
		{
			finish();
			return;
		}
		
		// load ZIP with bitmaps
		loadAssetsZIPAction = new LoadAssetsZIPAction();
		loadAssetsZIPAction.addEventListener(ProgressEvent.PROGRESS, loadAssetsZIPAction_progressHandler);
		loadAssetsZIPAction.addEventListener(Event.COMPLETE, loadAssetsZIPAction_completeHandler);
		loadAssetsZIPAction.addEventListener(ErrorEvent.ERROR, loadAssetsZIPAction_errorHandler);
		zipFileURL = lookLink.zipFileURL;
		if (!zipFileURL)
		{
			zipFileURL = lookLink.txtFileURL;
			var lastTXTIndex:int = zipFileURL.lastIndexOf(".txt");
			if (lastTXTIndex > 0)
				zipFileURL = zipFileURL.substring(0, lastTXTIndex) + ".txt" + 
					zipFileURL.substring(lastTXTIndex + 4);
		}
		loadAssetsZIPAction.start(zipFileURL);
	}
	
	private function urlLoader_errorHandler(event:ErrorEvent):void
	{
		finish("failed to load look file from " + lookLink.txtFileURL + ": " + event.text);
	}
	
	private function loadAssetsZIPAction_progressHandler(event:ProgressEvent):void
	{
		indicateProgress((urlLoader.bytesTotal + event.bytesLoaded) / 
			(urlLoader.bytesTotal + event.bytesTotal));
	}
	
	private function loadAssetsZIPAction_completeHandler(event:Event):void
	{
		look.assetMap = loadAssetsZIPAction.assetMap;
		finish();
	}
	
	private function loadAssetsZIPAction_errorHandler(event:ErrorEvent):void
	{
		finish(event.text);
	}
	
}
}