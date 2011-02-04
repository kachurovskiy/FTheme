package com.fTheme.controller.look
{
import com.fTheme.controller.FThemeController;
import com.fTheme.controller.asset.AssetManager;
import com.fTheme.controller.look.actions.ILoadLooksAction;
import com.fTheme.controller.look.actions.LoadLookAction;
import com.fTheme.controller.look.actions.LoadLooksAction;

import flash.events.ErrorEvent;
import flash.events.Event;
import flash.events.EventDispatcher;

import mx.collections.ArrayCollection;
import mx.core.ClassFactory;
import mx.core.IFactory;
import mx.styles.IStyleManager2;
import mx.styles.StyleManager;

/**
 * Dispatched when manager finishes it's initialization. 
 */
[Event(name="init", type="flash.events.Event")]
/**
 * Dispatched when looks has failed to load.
 */
[Event(name="error", type="flash.events.ErrorEvent")]

/**
 * Applies customization to the whole application based on plain text 
 * customization property values.
 */
public class LookManager extends EventDispatcher
{

	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------

	/**
	 * Constructor.
	 */
	public function LookManager()
	{
		super();
	}
	
	//--------------------------------------------------------------------------
	//
	//  Variables
	//
	//--------------------------------------------------------------------------
	
	private var controller:FThemeController = FThemeController.instance;
	
	private var assetManager:AssetManager = FThemeController.instance.assetManager;
	
	private var properties:Vector.<LookProperty> = new Vector.<LookProperty>();
	
	private var propertyMap:Object = {};
	
	private var styleManager:IStyleManager2 = StyleManager.getStyleManager(null);
	
	private var lookLoadAction:LoadLookAction;
	
	private var lookLoadsAction:ILoadLooksAction;
	
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  defaultLookLink
	//----------------------------------

	private var _defaultLookLink:LookLink;

	[Bindable("__NoChangeEvent__")]
	/**
	 * Default look link.
	 */
	public function get defaultLookLink():LookLink
	{
		return _defaultLookLink;
	}
	
	//----------------------------------
	//  defaultLook
	//----------------------------------
	
	[Bindable("__NoChangeEvent__")]
	/**
	 * Default look that has no explicit styles defined and therefore sets
	 * all look properties to their default values.
	 */
	public function get defaultLook():Look
	{
		return _defaultLookLink.look;
	}
	
	//--------------------------------------
	//  errorText
	//--------------------------------------

	private var _errorText:String;

	[Bindable("error")]
	/**
	 * If list of looks has failed to load or some other initialization error
	 * occured <code>ErrorEvent.ERROR</code> event is dispatched and error text
	 * is kept in this property.
	 */
	public function get errorText():String 
	{
		return _errorText;
	}

	//--------------------------------------
	//  lookLinks
	//--------------------------------------

	private var _lookLinks:ArrayCollection;
	
	[Bindable("lookLinksChange")]
	/**
	 * Collection of all available look links. May not be available right
	 * from the start so make sure to listen for change event.
	 */
	public function get lookLinks():ArrayCollection
	{
		return _lookLinks;
	}
	
	//--------------------------------------
	//  initialized
	//--------------------------------------

	private var _initialized:Boolean = false;

	[Bindable("init")]
	/**
	 * If manager has already loaded all initial looks or not.
	 */
	public function get initialized():Boolean 
	{
		return _initialized;
	}

	public function set initialized(value:Boolean):void
	{
		if (_initialized == value)
			return;
		
		_initialized = value;
		dispatchEvent(new Event("initializedChange"));
	}

	//--------------------------------------
	//  lookLink
	//--------------------------------------

	private var _lookLink:LookLink;

	[Bindable("lookLinkChange")]
	/**
	 * Currently selected look link.
	 */
	public function get lookLink():LookLink 
	{
		return _lookLink;
	}

	public function set lookLink(value:LookLink):void
	{
		if (_lookLink == value)
			return;
		
		if (_lookLink)
		{
			_lookLink.removeEventListener("statusChange", lookLink_statusChangeHandler);
			if (lookLoadAction)
				lookLoadAction = null;
		}
		
		_lookLink = value;
		
		if (_lookLink)
		{
			if (_lookLink.status == LookLinkStatus.LOADED)
			{
				look = _lookLink.look;
			}
			else
			{
				// look may be already loading so listen not to the load action
				// but to the lookLink itself
				_lookLink.addEventListener("statusChange", lookLink_statusChangeHandler);
				
				if (_lookLink.status == LookLinkStatus.NOT_LOADED)
				{
					lookLoadAction = new LoadLookAction();
					lookLoadAction.addEventListener(ErrorEvent.ERROR,
						lookLoadAction_errorHandler);
					lookLoadAction.start(_lookLink);
				}
			}
		}
		
		dispatchEvent(new Event("lookLinkChange"));
	}

	//--------------------------------------
	//  look
	//--------------------------------------

	private var _look:Look;

	[Bindable("lookChange")]
	/**
	 * Currently selected look.
	 */
	public function get look():Look 
	{
		return _look;
	}

	public function set look(value:Look):void
	{
		if (_look == value)
			return;
		
		if (_look)
			clearLook(_look);
		
		_look = value;
		
		if (_look)
			applyLook(_look);
		
		dispatchEvent(new Event("lookChange"));
	}

	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------
	
	private function addProperty(property:LookProperty):void
	{
		if (propertyMap[property.name])
			throw new Error("Property " + property.name + " is already added");
		
		properties.push(property);
		propertyMap[property.name] = property;
	}
	
	private function applyLook(look:Look):void
	{
		// set look assets to AssetManager so that bitmap fills could be drawn
		var assetMap:Object = look.assetMap;
		if (assetMap)
		{
			for (var id:String in assetMap)
			{
				assetManager.setAsset(id, assetMap[id]);
			}
		}
		
		// set our LookProperty values from the given look
		var propertyValues:Array = look.propertyValues;
		var n:int = propertyValues.length;
		var appliedProperties:Object = {};
		var i:int;
		var property:LookProperty;
		for (i = 0; i < n; i++)
		{
			var propertyValue:PropertyValue = propertyValues[i];
			property = propertyMap[propertyValue.name];
			if (!property)
			{
				trace("Property " + propertyValue.name + " not found");
				continue;
			}
			
			appliedProperties[propertyValue.name] = true;
			property.value = propertyValue.value;
		}
		
		n = properties.length;
		for (i = 0; i < n; i++)
		{
			property = properties[i];
			if (appliedProperties[property.name])
				continue;
			
			property.value = property.defaultValue;
		}
		
		styleManager.setStyleDeclaration("global", styleManager.getStyleDeclaration("global"), true);
	}
	
	private function clearLook(look:Look):void
	{
		var assetMap:Object = look.assetMap;
		if (assetMap)
		{
			for (var id:String in assetMap)
			{
				assetManager.clearAsset(id);
			}
		}
	}
	
	public function initialize():void
	{
		addProperty(new ColorArrayProperty("alternatingItemColors", ""));
		
		addProperty(new ColorProperty("color", "0x000000"));
		addProperty(new ColorProperty("rollOverColor", "0xCEDBEF"));
		addProperty(new ColorProperty("selectionColor", "0xA8C6EE"));
		addProperty(new ColorProperty("errorColor", "0xCC0000"));
		
		addProperty(new FillProperty("applicationFill", "0xFFFFFF"));
		
		addProperty(new FillProperty("panelFill", "0xFFFFFF"));
		addProperty(new StrokeProperty("panelStroke", "0x888888 alpha 0.5"));
		addProperty(new NumberProperty("panelCornerRadius", "0"));
		
		addProperty(new FillProperty("progressBarFill", "0xFFFFFF 0xD8D8D8"));
		addProperty(new FillProperty("progressBarTrackFill", "0x9A9A9A 0xBDBDBD"));
		addProperty(new StrokeProperty("progressBarStroke", "0x888888"));
		addProperty(new NumberProperty("progressBarHeight", "10"));
		
		addProperty(new FillProperty("titlebarFill", "0xE2E2E2 0xD9D9D9"));
		addProperty(new StrokeProperty("titlebarStroke", "0x888888"));
		var titlebarColor:ColorProperty = new ColorProperty("titlebarColor", "0x000000");
		// MX title label color can not be set in skin, set it to corresponding CSS class
		titlebarColor.addStyleInjection(".windowStyles", "color");
		addProperty(titlebarColor);
		
		addProperty(new FillProperty("contentFill", "0xFFFFFF"));
		addProperty(new StrokeProperty("contentStroke", "0x888888"));
		addProperty(new NumberProperty("contentCornerRadius", "0"));
		
		addProperty(new StrokeProperty("borderStroke", "0x888888"));
		
		addProperty(new FillProperty("buttonUpFill", 
			"0xFFFFFF 0xF3F3F3 ratio 0.5 0xEAEAEA ratio 0.51 0xD3D3D3"));
		addProperty(new FillProperty("buttonOverFill", 
			"0xD0D1D1 0xC7C9C9 ratio 0.5 0xB5B6B7 ratio 0.51 0xA4A5A6"));
		addProperty(new FillProperty("buttonDownFill",
			"0xBCBCBC 0xB5B6B7 ratio 0.5 0xAAAAAB ratio 0.51 0x9C9E9F"));
		addProperty(new FillProperty("buttonSelectedFill",
			"0xBCBCBC 0xB5B6B7 ratio 0.5 0xAAAAAB ratio 0.51 0x9C9E9F"));
		addProperty(new FillProperty("buttonDisabledFill", 
			"0xFFFFFF 0xFAFAFA ratio 0.5 0xF5F5F5 ratio 0.51 0xEAEAEA"));
		addProperty(new StrokeProperty("buttonStroke", "0x888888"));
		addProperty(new NumberProperty("buttonCornerRadius", "3"));
		addProperty(new NumberProperty("buttonMinWidth", "21"));
		addProperty(new NumberProperty("buttonMinHeight", "21"));
		
		addProperty(new NumberProperty("checkBoxSize", "13"));
		
		addProperty(new NumberProperty("radioButtonSize", "13"));
		addProperty(new NumberProperty("radioButtonDotSize", "5"));
		
		addProperty(new FillProperty("headerFill", 
			"0xFFFFFF 0xF7F7F7 ratio 0.35 0xF2F2F2 ratio 0.36 0xD5D5D5"));
		
		// headerColors are used in DateChooser header (allows only 2 colors)
		addProperty(new ColorArrayProperty("headerColors", 
			"0xFFFFFF 0xD8D8D8", 2, 2));
		
		addProperty(new StrokeProperty("highlightStroke", "0xFFFFFF alpha 0.2"));
		
		addProperty(new FillProperty("toolbarFill", "0xE0E0E0 0xDADADA"));
		addProperty(new ColorProperty("toolbarColor", "0x000000"));
		addProperty(new StrokeProperty("toolbarStroke", "0xC0C0C0"));
		addProperty(new FillProperty("toolbarButtonUpFill", "0xFFFFFF alpha 0"));
		addProperty(new FillProperty("toolbarButtonOverFill", "0xCEDBEF"));
		addProperty(new FillProperty("toolbarButtonDownFill", "0xA8C6EE"));
		addProperty(new FillProperty("toolbarButtonDisabledFill", "0xFFFFFF alpha 0.2"));
		
		addProperty(new FillProperty("controlbarFill", "0xDADADA 0xC5C5C5"));
		addProperty(new StrokeProperty("controlbarStroke", "0xC0C0C0"));
		addProperty(new ColorProperty("controlbarColor", "0x000000"));
		
		addProperty(new FillProperty("inputFill", "0xFFFFFF"));
		addProperty(new StrokeProperty("inputStroke", "0x888888"));
		addProperty(new NumberProperty("inputCornerRadius", "0"));
		
		addProperty(new FillProperty("hScrollBarTrackFill", "0xCACACA"));
		addProperty(new FillProperty("vScrollBarTrackFill", "0xCACACA"));
		addProperty(new FillProperty("hScrollBarThumbUpFill", "0xFCFCFC 0xFBFBFB ratio 0.50 0xF1F1F1 ratio 0.51"));
		addProperty(new FillProperty("hScrollBarThumbOverFill", "0xD0D0D0 0xCFCFCF ratio 0.5 0xB8B8B8 ratio 0.51"));
		addProperty(new FillProperty("hScrollBarThumbDownFill", "0xC0C0C0 ratio 0.5 0xA1A1A1 ratio 0.51"));
		addProperty(new FillProperty("vScrollBarThumbUpFill", "0xFCFCFC 0xFBFBFB ratio 0.50 0xF1F1F1 ratio 0.51 rotation 0"));
		addProperty(new FillProperty("vScrollBarThumbOverFill", "0xD0D0D0 0xCFCFCF ratio 0.5 0xB8B8B8 ratio 0.51 rotation 0"));
		addProperty(new FillProperty("vScrollBarThumbDownFill", "0xC0C0C0 ratio 0.5 0xA1A1A1 ratio 0.51 rotation 0"));
		addProperty(new NumberProperty("scrollBarButtonSize", "17"));
		addProperty(new NumberProperty("scrollBarThumbMinSize", "17"));
		addProperty(new NumberProperty("scrollBarSize", "14"));
		addProperty(new NumberProperty("scrollBarCornerRadius", "0"));
		addProperty(new StrokeProperty("scrollBarStroke", "0x686868 pixelHinting true"));
		
		addProperty(new FillProperty("sliderTrackFill", "0xCACACA"));
		addProperty(new StrokeProperty("sliderTrackStroke", "0x686868"));
		addProperty(new NumberProperty("sliderTrackSize", "6"));
		addProperty(new NumberProperty("sliderTrackCornerRadius", "3"));
		addProperty(new NumberProperty("sliderThumbSize", "11"));
		
		addProperty(new ColorProperty("symbolColor", "0x444444"));
		addProperty(new FillProperty("symbolFill", "0x444444"));
		
		_defaultLookLink = new LookLink();
		// set all properties to their default values by passing empty look
		var defaultLook:Look = new Look("Default");
		defaultLook.licenses = Vector.<License>([ new License("MIT") ]);
		_defaultLookLink.look = defaultLook;
		lookLink = _defaultLookLink;
		
		var factory:IFactory = controller.options.loadLooksActionFactory;
		lookLoadsAction = factory ? factory.newInstance() : new LoadLooksAction();
		lookLoadsAction.addEventListener(Event.COMPLETE, loadLooksAction_someHandler);
		lookLoadsAction.addEventListener(ErrorEvent.ERROR, loadLooksAction_someHandler);
		lookLoadsAction.start(_defaultLookLink);
	}
	
	public function destroy():void
	{
		lookLink = null;
		look = null;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Event handlers
	//
	//--------------------------------------------------------------------------
	
	private function lookLink_statusChangeHandler(event:Event):void
	{
		if (_lookLink.status == LookLinkStatus.LOADED)
			look = _lookLink.look;
	}
	
	private function loadLooksAction_someHandler(event:Event):void
	{
		_lookLinks = lookLoadsAction.lookLinks;
		dispatchEvent(new Event("lookLinksChange"));
		
		// initialization is finished
		if (event.type == "complete")
		{
			dispatchEvent(new Event(Event.INIT));
		}
		else
		{
			var errorEvent:ErrorEvent = ErrorEvent(event);
			_errorText = errorEvent.text;
			dispatchEvent(errorEvent);
		}
	}
	
	private function lookLoadAction_errorHandler(event:ErrorEvent):void
	{
		dispatchEvent(event);
	}
	
}
}