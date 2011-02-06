package com.fTheme.look
{
import flash.events.EventDispatcher;

/**
 * Represents look author specified in look text file with "&64;author" directive.
 */
public class Author extends NameURL
{
	
	public function Author(text:String = null)
	{
		super(text);
	}
	
}
}