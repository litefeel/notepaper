package com.litefeel.utils 
{
	/**
	 * ...
	 * @author lite3
	 */
	public class IntUtil
	{
		/**
		 * 
		 * @param	n
		 * @param	minLen	指定返回字符串的最小长度不够则前面用0补齐 0:表示自动长度
		 * @param	radix	指定要用于数字到字符串的转换的基数（从 2 到 36）。如果未指定 radix 参数，则默认值为 10。
		 * @return
		 */
		public static function toString(n:int, minLen:int = 0, radix:int = 10):String
		{
			var s:String = n.toString(radix);
			for (var i:int = minLen - s.length; i > 0; i--)
			{
				s = "0" + s;
			}
			return s;
		}
		
	}

}