package com.litefeel.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author lite3
	 */
	public class LocalBridgeEvent extends Event 
	{
		
		public function LocalBridgeEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new LocalBridgeEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("LocalBridgeEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}