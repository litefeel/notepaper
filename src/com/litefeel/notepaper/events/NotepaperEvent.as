package com.litefeel.notepaper.events 
{
	import flash.events.Event;
	import flash.globalization.StringTools;
	
	/**
	 * ...
	 * @author lite3
	 */
	public class NotepaperEvent extends Event 
	{
		
		static public const DATA_CHANGE:String = "dataChange";
		
		static public const CREATE:String = "create";
		static public const DELETE:String = "delete";
		static public const HIDE:String = "hide";
		
		static public const SHOW_BIG_SIZE:String = "showBigSize";
		static public const SHOW_NORMAL_SIZE:String = "showNormalSize";
		
		static public const START_MOVE:String = "startMove";
		static public const START_RESIZE:String = "startResize";
		
		public function NotepaperEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new NotepaperEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("NotepaperEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}