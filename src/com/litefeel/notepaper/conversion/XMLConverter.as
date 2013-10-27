package com.litefeel.notepaper.conversion 
{
	import com.litefeel.notepaper.vo.NotepaperVo;
	/**
	 * ...
	 * @author lite3	http://lite3.cn
	 */
	public class XMLConverter
	{
		
		static public function createNotepaperVoList(xmlList:XMLList):Vector.<NotepaperVo>
		{
			var len:int = xmlList.length();
			var list:Vector.<NotepaperVo> = len > 0 ? new Vector.<NotepaperVo>(len) : null;
			for (var i:int = 0; i < len; i++)
			{
				list[i] = createNotepaperVo(xmlList[i]);
			}
			return list; 
		}
		
		public function createNotepaperVo(xml:XML):NotepaperVo
		{
			var vo:NotepaperVo = new NotepaperVo(null, xml.@subject, xml.@content, true, xml.@x, xml.@y);
			if ("@w" in xml) vo.width = xml.@w;
			if ("@h" in xml) vo.height = xml.@h;
			if ("@isShowSubject" in xml) vo.isShowSubject = "true" == xml.@isShowSubject;
			return vo;
		}
		
		/**
		 * 
		 * @param	vector
		 * @return
		 */
		static public function notepaperVoToXML(vector:Vector.<NotepaperVo>):XMLList
		{
			var len:int = vector.length;
			var xml:XML = <notepaper/>;
			for (var i:int = 0; i < len; i++)
			{
				var tmp:XML = <notepaper/>;
				tmp.@subject = subject;
				tmp.@content = content;
				tmp.@x = x;
				tmp.@y = y;
				tmp.@w = width;
				tmp.@h = height;
				tmp.@isShowSubject = isShowSubject;
				xml.appendChild(tmp);
			}
			return xml.notepaper;
		}
	}
}