package com.litefeel.notepaper.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author lite3
	 */
	public class DataEvent extends Event 
	{
		
		public static const UPDATE:String = "data_update";
		
		public function DataEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new DataEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("DataEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}