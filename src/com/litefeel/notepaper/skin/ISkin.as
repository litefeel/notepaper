package com.litefeel.notepaper.skin 
{
	import flash.display.NativeWindow;
	
	/**
	 * ...
	 * @author lite3
	 */
	public interface ISkin 
	{
		public function setWindow(nate:NativeWindow):void;
		public function setSkinValue():void;
		public function getSkinValue():void;
		public function getTitle():String;
		public function setTitle(s:String):void;
		public function getContent():String;
		public function setContent(s:String):void;
	}
	
}