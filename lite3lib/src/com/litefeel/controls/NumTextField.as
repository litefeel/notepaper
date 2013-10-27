/**
 * NumTextField 继承于  TextField
 * 
 * 禁用的 属性 和方法
 * 		override public function set multiline(value:Boolean):void { } 
 *		override public function set type(value:String):void { } 
 *		override public function set text(value:String):void { } 
 *		override public function set htmlText(value:String):void { } 
 *		override public function appendText(newText:String):void { }
 * 
 * 增加的属性
 * 		number 可读写	NumberText 的值 
 */

package com.litefeel.controls 
{
	import flash.events.Event;
	import flash.events.TextEvent;
	import flash.text.TextField;
	
	/**
	 * www.litefeel.com
	 * lite3@qq.com
	 * @author lite3
	 */
	public class NumTextField extends TextField
	{
		private var num:Number = 0;
		private var ignoreChange:Boolean = false;
		
		public function NumTextField() 
		{
			super.restrict = '.0-9';
			super.maxChars = 17;
			super.type = "input";
			super.text = getNumStr();
			super.height = super.textHeight + 4;
			super.wordWrap = false;
			super.multiline = false;
			super.border = true;
			super.addEventListener(Event.CHANGE, changeHandler);
		}
		
		/**
		 * NumTextField的值  可读写
		 */
		public function get number():Number { return num; }
		public function set number(value:Number):void
		{
			if (isNaN(value) || value < 0) value = 0;
			
			num = value;
			super.text = getNumStr();
		}
		
		// 禁用的方法及函数
		override public function set multiline(value:Boolean):void { } 
		override public function set type(value:String):void { } 
		override public function set text(value:String):void { } 
		override public function set htmlText(value:String):void { } 
		override public function appendText(newText:String):void { }
		
		private function getNumStr():String
		{
			var s:String = num + "";
			if ( -1 == s.indexOf(".")) s += ".";
			return s;
		}
		
		private function changeHandler(e:Event):void 
		{
			if (ignoreChange) return;
			
			var old:Number = num;
			number = parseFloat(text);
			super.text = getNumStr();
			if (old == num) return;
			
			if (old<1 && num >= 1
				&& selectionBeginIndex == selectionEndIndex
				&& text.charAt(selectionBeginIndex-1) == ".")
			{
				setSelection(1, 1);
			}
			
			ignoreChange = true;
			dispatchEvent(new Event(Event.CHANGE));
			ignoreChange = false;
		}
	}
}