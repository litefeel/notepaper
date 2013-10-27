package com.litefeel.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author lite3
	 */
	public class SliderEvent extends Event 
	{
		
		public static const CHANGING:String = "changing";
		public static const CHANGE:String = "change";
		
		public var value:Number;
		
		public function SliderEvent(type:String, value:Number) 
		{ 
			super(type, false, false);
			this.value = value;
		} 
		
		public override function clone():Event 
		{ 
			return new SliderEvent(type, value);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("SliderEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
	}
}