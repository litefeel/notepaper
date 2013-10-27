/**
 * NumberText 继承于  TextField
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
 * 增加的方法
 * 		public function appendChar(char:String):void
 * 			在末尾添加一个数字字符
 * 
 * 		public function removeLastChar():void
 * 			从末尾删除一个数字字符
 * 
 * 事件 :
 * 		Event.CHANGE
 */

package com.litefeel.controls 
{
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.TextEvent;
	import flash.text.TextField;
	
	/**
	 * www.litefeel.com
	 * lite3@qq.com
	 * @author lite3
	 */
	public class NumberText extends TextField
	{
		private const dot:String = '.';
		private const dotCode:int = 46;
		
		private var hasDot:Boolean = false;
		private var numStr:String = "0.";
		
		private var limit:Boolean = false;
		private var txt:TextField = new TextField();
		
		public function NumberText() 
		{
			super.text = numStr;
			super.height = super.textHeight + 4;
			super.wordWrap = false;
			super.multiline = false;
			super.border = true;
			super.addEventListener(KeyboardEvent.KEY_DOWN, inputHandler);
		}
		
		/**
		 * 删除最后一个字符
		 */
		public function removeLastChar():void
		{
			if (numStr.substr(numStr.length - 1) != dot)
			{
				numStr = numStr.slice(0, -1);
			}else if(hasDot)
			{
				hasDot = false;
			}else
			{
				numStr = numStr.slice(0, -2) + dot;
				if (dot == numStr) numStr = "0" + dot;
			}
			super.text = numStr;
		}
		
		/**
		 * 在末尾添加一个字符, 0-9 .
		 * 如果 char 为 null 或 '', 则什么也不做
		 * 
		 * @param	char
		 */
		public function appendChar(char:String):void
		{
			if (!char) return;
			
			var charCode:int = char.charCodeAt(0);
			// 非 1 - 9 .
			if ((charCode < 48 || charCode > 57) && 46 != charCode)
				return;
			
			// .
			if (dotCode == charCode)
			{
				hasDot = true;
				return;
			}
			
			var char:String = String.fromCharCode(charCode);
			var str:String = hasDot? numStr : numStr.slice(0, -1);
			str += char;
			str = parseFloat(str).toString();
			if ( -1 == str.indexOf('.')) str += '.';
			
			numStr = str;
			super.text = numStr;
		}
		
		/**
		 * NumberText的值  可读写
		 */
		public function get number():Number { return parseFloat(numStr); }
		public function set number(value:Number):void
		{
			if (isNaN(value) || value < 0) value = 0;
			
			hasDot = value != (value >> 0);
			numStr = value.toString();
			if (!hasDot) numStr += dot;
			super.text = numStr;
		}
		
		// 禁用的方法及函数
		override public function set multiline(value:Boolean):void { } 
		override public function set type(value:String):void { } 
		override public function set text(value:String):void { } 
		override public function set htmlText(value:String):void { } 
		override public function appendText(newText:String):void { }
		
		
		private function inputHandler(e:KeyboardEvent):void 
		{
			// 退格
			if (8 == e.keyCode)
			{
				removeLastChar();
				return;
			}
			
			if (numStr.length >= 17) return;
			
			var prevNum:Number = number;
			appendChar(String.fromCharCode(e.charCode));
			
			if (prevNum != number)
			{
				dispatchEvent(new Event(Event.CHANGE));
			}
		}
		
	}
	
}