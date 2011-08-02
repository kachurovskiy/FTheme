package com.fTheme.look
{
import flash.events.EventDispatcher;

/**
 * Represents look author specified in look text file with <code>&#64;author</code> directive.
 */
public class Author extends NameURL
{
	
	/**
	 * Constructor.
	 */
	public function Author(text:String = null)
	{
		super(text);
	}
	
}
}