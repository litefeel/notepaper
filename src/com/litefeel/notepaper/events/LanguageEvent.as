package com.litefeel.notepaper.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author lite3
	 */
	public class LanguageEvent extends Event 
	{
		static public const LANGUAGE_CHANGE:String = "languageChange";
		
		public function LanguageEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new LanguageEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("LanguageEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}