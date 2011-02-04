package com.fTheme.controller
{
import mx.core.IFactory;

/**
 * FTheme initialization options.
 */
public class FThemeOptions
{
	public function FThemeOptions(lookLinksXMLURL:String = null,
								  loadLooksActionFactory:IFactory = null)
	{
		this.lookLinksXMLURL = lookLinksXMLURL;
		this.loadLooksActionFactory = loadLooksActionFactory;
	}
	
	/**
	 * Default URL for the file with look links XML file. Setting it e.g. to
	 * "lookLinks.xml" will cause manager use that file if nothing is specified
	 * in Flash Vars.
	 */
	public var lookLinksXMLURL:String;
	
	/**
	 * Factory for initialization action. Product should implement <code>ILoadLooksAction</code>.
	 */
	public var loadLooksActionFactory:IFactory;
	
	/**
	 * If specified, look links XML is not loaded and given names are used.
	 */
	public var lookLinkNames:Array /* of String */;
	
	/**
	 * If <code>lookLinkNames</code> are specified and looks are located not in
	 * the same directory as the SWF file, base directory URL can be specified in
	 * <code>lookLinksURLBase</code>.
	 */
	public var lookLinksURLBase:String;
	
	/**
	 * Whether to show default look in the list of available looks or not.
	 */
	public var showDefaultLook:Boolean = true;
	
}
}