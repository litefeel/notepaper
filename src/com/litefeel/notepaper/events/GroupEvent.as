package com.litefeel.notepaper.events 
{
	import com.litefeel.notepaper.vo.GroupVo;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author lite3
	 */
	public class GroupEvent extends Event 
	{
		public static const CREATE:String = "group_create";
		public static const DELETE:String = "group_delete";
		public static const MODIFY:String = "group_modify";
		
		public var groupVo:GroupVo;
		
		public function GroupEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, groupVo:GroupVo = null) 
		{ 
			super(type, bubbles, cancelable);
			this.groupVo = groupVo;
		} 
		
		public override function clone():Event 
		{ 
			return new GroupEvent(type, bubbles, cancelable, groupVo);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("GroupEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}