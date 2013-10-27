package com.litefeel.notepaper.vo
{
	import com.litefeel.notepaper.view.NotepaperWindow;
	/**
	 * ...
	 * @author lite3
	 */
	public class NotepaperVo
	{
		public var id:int;
		public var x:Number;
		public var y:Number;
		public var width:int;
		public var height:int;
		public var groupId:int;	// 所在的分组id
		public var subject:String;	// 标题
		public var content:String;	// 内容
		public var isShowSubject:Boolean;	// 是否显示标题
		public var onTop:Boolean = false;
		public var window:NotepaperWindow;	// 窗口
		public var date:Date;
		
		
		public function NotepaperVo(window:NotepaperWindow, subject:String = "", content:String = "", isShowSubject:Boolean = true, x:Number = 0, y:Number = 0, width:int = 200, height:int = 206)
		{
			this.window = window;
			this.subject = subject;
			this.content = content;
			this.isShowSubject = isShowSubject;
			this.x = x;
			this.y = y;
			this.width = width;
			this.height = height;
		}
		
		public static function createNotepaperVo(xml:XML):NotepaperVo
		{
			var vo:NotepaperVo = new NotepaperVo(null, xml.@subject, xml.@content, true, xml.@x, xml.@y);
			if ("@w" in xml) vo.width = xml.@w;
			if ("@h" in xml) vo.height = xml.@h;
			vo.groupId = xml.@gid;
			vo.onTop = "true" == xml.@onTop;
			if ("@isShowSubject" in xml) vo.isShowSubject = "true" == xml.@isShowSubject;
			return vo;
		}
		
		public function toXML():XML
		{
			var xml:XML = new XML(<notepaper/>);
			xml.@subject = subject;
			xml.@content = content;
			xml.@x = x;
			xml.@y = y;
			xml.@w = width;
			xml.@h = height;
			xml.@isShowSubject = isShowSubject;
			xml.@gid = groupId;
			xml.@onTop = onTop;
			return xml;
		}
	}

}