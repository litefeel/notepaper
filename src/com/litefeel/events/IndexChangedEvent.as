package com.litefeel.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author lite3
	 */
	public class IndexChangedEvent extends Event 
	{
		
		static public const INDEX_CHANGE:String = "indexChange";
		
		public var oldIndex:int;
		public var newIndex:int;
		
		public function IndexChangedEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, oldIndex:int = 0, newIndex:int = 0) 
		{ 
			super(type, bubbles, cancelable);
			this.oldIndex = oldIndex;
			this.newIndex = newIndex;
		} 
		
		public override function clone():Event 
		{ 
			return new IndexChangedEvent(type, bubbles, cancelable, oldIndex, newIndex);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("IndexChangedEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}