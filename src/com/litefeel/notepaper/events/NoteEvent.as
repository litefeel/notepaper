package com.litefeel.notepaper.events 
{
	import com.litefeel.notepaper.vo.NotepaperVo;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author lite3
	 */
	public class NoteEvent extends Event 
	{
		public static const CREATE:String = "note_create";
		public static const DELETE:String = "note_delete";
		public static const MODIFY:String = "note_modify";
		
		public var noteVo:NotepaperVo;
		
		
		public function NoteEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, noteVo:NotepaperVo = null) 
		{ 
			super(type, bubbles, cancelable);
			this.noteVo = noteVo;
		} 
		
		public override function clone():Event 
		{ 
			return new NoteEvent(type, bubbles, cancelable, noteVo);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("NoteEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}