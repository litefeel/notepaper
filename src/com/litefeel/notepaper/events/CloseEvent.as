package com.litefeel.notepaper.events 
{
	import flash.events.Event;
	import flash.globalization.StringTools;
	
	/**
	 * ...
	 * @author lite3
	 */
	public class CloseEvent extends Event 
	{
		public static const CLOSE:String = "_close";
		
		public var selectedIndex:uint;
		public var isCloseBtn:Boolean = false;
		
		public function CloseEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, selectedIndex:uint = 0, isCloseBtn:Boolean = false) 
		{ 
			super(type, bubbles, cancelable);
			this.selectedIndex = selectedIndex;
			this.isCloseBtn = isCloseBtn;
		} 
		
		public override function clone():Event 
		{ 
			return new CloseEvent(type, bubbles, cancelable, selectedIndex, isCloseBtn);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("CloseEvent", "type", "bubbles", "cancelable", "eventPhase", "selectedIndex", "isCloseBtn"); 
		}
		
	}
	
}