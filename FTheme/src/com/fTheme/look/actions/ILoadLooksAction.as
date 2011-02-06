package com.fTheme.look.actions
{
import com.fTheme.look.LookLink;

import flash.events.IEventDispatcher;

import mx.collections.ArrayCollection;

/**
 * Interface for actions that can load initial set of looks for look manager.
 * Default implementation is <code>LoadLooksAction</code>.
 */
public interface ILoadLooksAction extends IEventDispatcher
{
	
	/**
	 * Collection of loaded look links. Is available right after complete or error event. 
	 */
	function get lookLinks():ArrayCollection; 
	
	/**
	 * Starts the action.
	 * 
	 * <p>When action finishs it dispatches <code>Event.COMPLETE</code> or 
	 * <code>ErrorEvent.ERROR</code>.</p>
	 */
	function start(defaultLookLink:LookLink):void;
	
}
}